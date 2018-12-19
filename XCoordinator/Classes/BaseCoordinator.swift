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
    open func registerGestureRecognizer(
        _ recognizer: UIGestureRecognizer,
        route: RouteType,
        progression: @escaping (UIGestureRecognizer) -> CGFloat,
        shouldFinish: @escaping (UIGestureRecognizer) -> Bool,
        completion: PresentationHandler? = nil) {

        var animation: TransitionAnimation?
        let target = GestureRecognizerTarget(recognizer: recognizer) { [weak self] recognizer in
            guard let `self` = self else { return }

            switch recognizer.state {
            case .possible, .failed:
                break
            case .began:
                let transition = self.prepareTransition(for: route)
                animation = transition.animation
                animation?.start()
                self.performTransition(transition, with: TransitionOptions(animated: true), completion: completion)
            case .changed:
                let transitionProgress = progression(recognizer)
                animation?.interactionController?.update(transitionProgress)
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

    open func unregisterGestureRecognizer(_ recognizer: UIGestureRecognizer) {
        gestureRecognizerTargets.removeAll { $0.gestureRecognizer === recognizer }
    }
}
