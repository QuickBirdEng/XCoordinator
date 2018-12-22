//
//  BaseCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension BaseCoordinator {
    public typealias RootViewController = TransitionType.RootViewController
}

open class BaseCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let rootViewControllerBox = ReferenceBox<RootViewController>()
    private var gestureRecognizerTargets = [GestureRecognizerTarget]()

    // MARK: - Computed properties

    public var rootViewController: RootViewController {
        return rootViewControllerBox.get()!
    }

    // MARK: - Init

    public init(initialRoute: RouteType?) {
        rootViewControllerBox.set(generateRootViewController())
        initialRoute.map(prepareTransition).map(performTransitionAfterWindowAppeared)
    }

    public init(initialTransition: TransitionType?) {
        rootViewControllerBox.set(generateRootViewController())
        initialTransition.map(performTransitionAfterWindowAppeared)
    }

    // MARK: - Open methods

    open func presented(from presentable: Presentable?) {
        rootViewControllerBox.releaseStrongReference()
    }

    open func generateRootViewController() -> RootViewController {
        return RootViewController()
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        fatalError("Please override the \(#function) method.")
    }

    // MARK: - Private methods

    private func performTransitionAfterWindowAppeared(_ transition: TransitionType) {
        guard UIApplication.shared.keyWindow == nil else {
            return performTransition(transition, with: TransitionOptions(animated: false))
        }

        var windowAppearanceObserver: Any?

        rootViewController.beginAppearanceTransition(true, animated: false)
        windowAppearanceObserver = NotificationCenter.default.addObserver(forName: UIWindow.didBecomeKeyNotification, object: nil, queue: .main) { [weak self] _ in
            windowAppearanceObserver.map(NotificationCenter.default.removeObserver)
            windowAppearanceObserver = nil
            self?.performTransition(transition, with: TransitionOptions(animated: false))
            self?.rootViewController.endAppearanceTransition()
        }
    }
}

// MARK: - BaseCoordinator+UIGestureRecognizer

extension BaseCoordinator {
    open func registerInteractiveTransition<GestureRecognizer: UIGestureRecognizer>(
        for route: RouteType,
        triggeredBy recognizer: GestureRecognizer,
        progress: @escaping (GestureRecognizer) -> CGFloat,
        shouldFinish: @escaping (GestureRecognizer) -> Bool,
        completion: PresentationHandler? = nil) {

        return registerInteractiveTransition(
            { [weak self] in self?.prepareTransition(for: route) ?? .none() },
            triggeredBy: recognizer,
            progress: progress,
            shouldFinish: shouldFinish,
            completion: completion
        )
    }

    private func registerInteractiveTransition<GestureRecognizer: UIGestureRecognizer>(
        _ transitionGenerator: @escaping () -> TransitionType,
        triggeredBy recognizer: GestureRecognizer,
        progress: @escaping (GestureRecognizer) -> CGFloat,
        shouldFinish: @escaping (GestureRecognizer) -> Bool,
        completion: PresentationHandler? = nil) {

        var animation: TransitionAnimation?
        let target = Target(recognizer: recognizer) { [weak self] recognizer in
            guard let `self` = self else { return }

            switch recognizer.state {
            case .possible, .failed:
                break
            case .began:
                let transition = transitionGenerator()
                animation = transition.animation
                animation?.start()
                self.performTransition(
                    transition,
                    with: TransitionOptions(animated: true),
                    completion: completion
                )
            case .changed:
                animation?.interactionController?.update(progress(recognizer))
            case .cancelled:
                defer { animation?.cleanup() }
                animation?.interactionController?.cancel()
            case .ended:
                defer { animation?.cleanup() }
                if shouldFinish(recognizer) {
                    animation?.interactionController?.finish()
                } else {
                    animation?.interactionController?.cancel()
                }
            }
        }
        gestureRecognizerTargets.append(target)
    }

    open func unregisterInteractiveTransitions(triggeredBy recognizer: UIGestureRecognizer) {
        gestureRecognizerTargets.removeAll { target in
            guard target.gestureRecognizer === recognizer else { return false }
            recognizer.removeTarget(target, action: nil)
            return true
        }
    }
}
