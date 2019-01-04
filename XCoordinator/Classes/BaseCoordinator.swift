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

///
/// BaseCoordinator can (and is encouraged to) be used as a superclass for any custom implementation of a coordinator.
///
/// We encourage the use of already provided subclasses of BaseCoordinator such as
/// `NavigationCoordinator`, `TabBarCoordinator`, `ViewCoordinator`, `SplitCoordinator`
/// and `PageCoordinator`.
///
open class BaseCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let rootViewControllerBox = ReferenceBox<RootViewController>()
    private var gestureRecognizerTargets = [GestureRecognizerTarget]()

    // MARK: - Computed properties

    public var rootViewController: RootViewController {
        // swiftlint:disable:next force_unwrapping
        return rootViewControllerBox.get()!
    }

    // MARK: - Initialization

    ///
    /// Use this initializer to trigger a route before the coordinator is made visible.
    ///
    /// - Parameter initialRoute:
    ///     The route to be triggered before making the coordinator visible.
    ///     If you specify `nil`, no route is triggered.
    ///
    public init(initialRoute: RouteType?) {
        rootViewControllerBox.set(generateRootViewController())
        initialRoute.map(prepareTransition).map(performTransitionAfterWindowAppeared)
    }

    ///
    /// Use this initializer to perform a transition before the coordinator is made visible.
    ///
    /// - Parameter initialTransition:
    ///     The transition to be performed before making the coordinator visible.
    ///     If you specify `nil`, no transition is performed.
    ///
    public init(initialTransition: TransitionType?) {
        rootViewControllerBox.set(generateRootViewController())
        initialTransition.map(performTransitionAfterWindowAppeared)
    }

    // MARK: - Open methods

    open func presented(from presentable: Presentable?) {
        rootViewControllerBox.releaseStrongReference()
    }

    ///
    /// This method generates the `rootViewController` on initialization.
    ///
    /// This method is only called once during initalization. Make sure to use the result from
    /// `super.generateRootViewController()` when overriding to make sure transition animations
    /// work as expected.
    ///
    open func generateRootViewController() -> RootViewController {
        return RootViewController()
    }

    ///
    /// This method prepares transitions for routes.
    /// Override this method to define transitions for triggered routes.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
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
        windowAppearanceObserver = NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeKeyNotification, object: nil, queue: .main) { [weak self] _ in
            windowAppearanceObserver.map(NotificationCenter.default.removeObserver)
            windowAppearanceObserver = nil
            self?.performTransition(transition, with: TransitionOptions(animated: false))
            self?.rootViewController.endAppearanceTransition()
        }
    }
}

// MARK: - Interactive Transitions

extension BaseCoordinator {

    // MARK: - Registering

    open func registerInteractiveTransition<GestureRecognizer: UIGestureRecognizer>(
        for route: RouteType,
        triggeredBy recognizer: GestureRecognizer,
        handler: @escaping (GestureRecognizer, () -> TransitionAnimation?) -> Void,
        completion: PresentationHandler? = nil) {

        let animationGenerator = { [weak self] () -> TransitionAnimation? in
            guard let self = self else { return nil }
            let transition = self.prepareTransition(for: route)
            transition.animation?.start()
            self.performTransition(transition, with: TransitionOptions(animated: true), completion: completion)
            return transition.animation
        }

        let target = Target(recognizer: recognizer) { recognizer in
            handler(recognizer, animationGenerator)
        }

        gestureRecognizerTargets.append(target)
    }

    open func registerInteractiveTransition<GestureRecognizer: UIGestureRecognizer>(
        for route: RouteType,
        triggeredBy recognizer: GestureRecognizer,
        progress: @escaping (GestureRecognizer) -> CGFloat,
        shouldFinish: @escaping (GestureRecognizer) -> Bool,
        completion: PresentationHandler? = nil) {

        var animation: TransitionAnimation?
        return registerInteractiveTransition(
            for: route,
            triggeredBy: recognizer,
            handler: { recognizer, transition in
                switch recognizer.state {
                case .possible, .failed:
                    break
                case .began:
                    animation = transition()
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
            },
            completion: completion
        )
    }

    // MARK: - Unregistering

    open func unregisterInteractiveTransitions(triggeredBy recognizer: UIGestureRecognizer) {
        gestureRecognizerTargets.removeAll { target in
            guard target.gestureRecognizer === recognizer else { return false }
            recognizer.removeTarget(target, action: nil)
            return true
        }
    }
}
