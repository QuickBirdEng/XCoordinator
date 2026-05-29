//
//  BaseCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// BaseCoordinator can (and is encouraged to) be used as a superclass for any custom implementation of a coordinator.
///
/// It is also encouraged to use already provided subclasses of BaseCoordinator such as
/// `NavigationCoordinator`, `TabBarCoordinator`, `ViewCoordinator`, `SplitCoordinator`
/// and `PageCoordinator`.
///
@MainActor
open class BaseCoordinator<RouteType: Route, RootViewController: UIViewController>: Coordinator {

    // MARK: Stored properties

    private var removeParentChildren: () -> Void = {}
    private var gestureRecognizerTargets = [GestureRecognizerTarget]()
    
    ///
    /// The child coordinators that are currently in the view hierarchy.
    /// When performing a transition, children are automatically added and removed from this array
    /// depending on whether they are in the view hierarchy.
    ///
    public private(set) var children = [any Presentable]()

    // MARK: Computed properties

    /// The root view controller of this coordinator's flow.
    ///
    /// Its concrete type is the coordinator's `RootViewController` — e.g. a `UINavigationController`
    /// for a `NavigationCoordinator`. Transitions on this coordinator are performed against it.
    public private(set) var rootViewController: RootViewController

    /// The presentable view controller for this coordinator. Returns ``rootViewController`` by default.
    open var viewController: UIViewController! {
        rootViewController
    }

    // MARK: Initialization

    ///
    /// Creates a coordinator and optionally triggers a route before the coordinator is made visible.
    ///
    /// - Parameters:
    ///   - rootViewController: The root view controller for this coordinator's flow.
    ///   - initialRoute: A route to trigger before the coordinator becomes visible. Pass `nil` to skip.
    ///
    public init(rootViewController: RootViewController, initialRoute: RouteType?) {
        self.rootViewController = rootViewController
        initialRoute.map(prepareTransition).map(performTransitionAfterWindowAppeared)
    }

    ///
    /// Creates a coordinator and optionally performs a transition before the coordinator is made visible.
    ///
    /// - Parameters:
    ///   - rootViewController: The root view controller for this coordinator's flow.
    ///   - initialTransition: A transition to perform before the coordinator becomes visible. Pass `nil` to skip.
    ///
    public init(rootViewController: RootViewController, initialTransition: Transition<RootViewController>?) {
        self.rootViewController = rootViewController
        initialTransition.map(performTransitionAfterWindowAppeared)
    }

    ///
    /// Creates a coordinator and performs an initial transition — described with the transition builder —
    /// before the coordinator is made visible.
    ///
    /// - Parameters:
    ///   - rootViewController: The root view controller for this coordinator's flow.
    ///   - initialTransition: A transition-builder closure describing the transition to perform.
    ///
    public init(rootViewController: RootViewController,
                @TransitionBuilder<RootViewController> initialTransition: () -> Transition<RootViewController>) {
        self.rootViewController = rootViewController
        performTransitionAfterWindowAppeared(initialTransition())
    }

    // MARK: Open methods

    public func router<R: Route>(for route: R.Type) -> (any Router<R>)? {
        self as? BaseCoordinator<R, RootViewController>
    }

    open func presented(from presentable: (any Presentable)?) {}

    public func removeChildrenIfNeeded() {
        children.removeAll { $0.canBeRemovedAsChild() }
        removeParentChildren()
    }
    
    public func addChild(_ presentable: any Presentable) {
        children.append(presentable)
        presentable.registerParent(self)
    }
    
    public func removeChild(_ presentable: any Presentable) {
        children.removeAll { $0.viewController === presentable.viewController }
        removeChildrenIfNeeded()
    }

    ///
    /// This method prepares transitions for routes.
    /// Override this method to define transitions for triggered routes, using the transition builder DSL.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
    /// - Returns:
    ///     The prepared transition.
    ///
    @TransitionBuilder<RootViewController>
    open func prepareTransition(for route: RouteType) -> Transition<RootViewController> {
        fatalError("Please override the \(#function) method.")
    }

    public func registerParent(_ presentable: any Presentable & AnyObject) {
        let previous = removeParentChildren
        removeParentChildren = { [weak presentable] in
            previous()
            presentable?.childTransitionCompleted()
        }
    }

    // MARK: Private methods

    private func performTransitionAfterWindowAppeared(_ transition: Transition<RootViewController>) {
        guard !UIApplication.shared.windows.contains(where: { $0.isKeyWindow }) else {
            return performTransition(transition, with: TransitionOptions(animated: false))
        }

        var windowAppearanceObserver: Any?

        windowAppearanceObserver = NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeKeyNotification, object: nil, queue: .main) { [weak self] _ in
            windowAppearanceObserver.map(NotificationCenter.default.removeObserver)
            windowAppearanceObserver = nil
            DispatchQueue.main.async {
                self?.performTransition(transition, with: TransitionOptions(animated: false))
            }
        }
    }
}

extension Presentable {

    fileprivate func canBeRemovedAsChild() -> Bool {
        guard !(self is UIViewController) else { return true }
        guard let viewController else { return true }
        return !viewController.isInViewHierarchy
            && viewController.children.allSatisfy { $0.canBeRemovedAsChild() }
    }

}

extension UIViewController {

    fileprivate var isInViewHierarchy: Bool {
        isBeingPresented
            || presentingViewController != nil
            || presentedViewController != nil
            || parent != nil
            || viewIfLoaded?.window != nil
            || navigationController != nil
            || tabBarController != nil
            || splitViewController != nil
    }

}

// MARK: - Interactive Transitions

extension BaseCoordinator {

    // MARK: Registering

    ///
    /// Register an interactive transition triggered by a gesture recognizer.
    ///
    /// Also consider `registerInteractiveTransition(for:triggeredBy:progress:shouldFinish:completion:)` as it might make it easier
    /// to implement an interactive transition. This is meant for cases where the other method does not provide enough customization
    /// options.
    ///
    /// A target is added to the gestureRecognizer so that the handler is executed every time the state of the gesture recognizer changes.
    ///
    /// - Note:
    ///     Use `unregisterInteractiveTransition(triggeredBy:)` to remove previously added interactive transitions.
    ///
    /// - Parameters:
    ///     - route:
    ///         The route to be triggered when the gestureRecognizer begins.
    ///         Make sure that the transition behind is interactive as otherwise the transition is simply performed.
    ///     - recognizer:
    ///         The gesture recognizer to be used to update the interactive transition.
    ///     - handler:
    ///         The handler to update the interaction controller of the animation generated by the transition closure.
    ///         It receives the gestureRecognizer with which the handler has been registered, and a closure to perform
    ///         the transition — which returns the transition animation to control the interaction controller of
    ///         (`TransitionAnimation.start()` is automatically called).
    ///     - completion:
    ///         The closure to be called whenever the transition completes.
    ///         Hint: Might be called multiple times but only once per performing the transition.
    ///
    public func registerInteractiveTransition<GestureRecognizer: UIGestureRecognizer>(
        for route: RouteType,
        triggeredBy recognizer: GestureRecognizer,
        handler: @escaping (_ handlerRecognizer: GestureRecognizer, _ transition: () -> TransitionAnimation?) -> Void,
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

    ///
    /// Register an interactive transition triggered by a gesture recognizer.
    ///
    /// To get more customization options, check out `registerInteractiveTransition(for:triggeredBy:handler:completion:)`.
    ///
    /// A target is added to the gestureRecognizer so that the handler is executed every time the state of the gesture recognizer changes.
    ///
    /// - Note:
    ///     Use `unregisterInteractiveTransition(triggeredBy:)` to remove previously added interactive transitions.
    ///
    /// - Parameters:
    ///     - route:
    ///         The route to be triggered when the gestureRecognizer begins.
    ///         Make sure that the transition behind is interactive as otherwise the transition is simply performed.
    ///     - recognizer:
    ///         The gesture recognizer to be used to update the interactive transition.
    ///     - progress:
    ///         Return the progress as CGFloat between 0 (start) and 1 (finish).
    ///     - shouldFinish:
    ///         Decide depending on the gestureRecognizer's state whether to finish or cancel a given transition.
    ///     - completion:
    ///         The closure to be called whenever the transition completes.
    ///         Hint: Might be called multiple times but only once per performing the transition.
    ///
    public func registerInteractiveTransition<GestureRecognizer: UIGestureRecognizer>(
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
                @unknown default:
                    break
                }
            },
            completion: completion
        )
    }

    // MARK: Unregistering

    ///
    /// Unregisters a previously registered interactive transition.
    ///
    /// Unregistering is not mandatory to prevent reference cycles, etc.
    /// It is useful, though, to remove previously registered interactive transitions that are no longer needed or wanted.
    ///
    /// - Parameter recognizer:
    ///     The recognizer to unregister interactive transitions for.
    ///     This method will unregister all interactive transitions with that gesture recognizer.
    ///
    public func unregisterInteractiveTransitions(triggeredBy recognizer: UIGestureRecognizer) {
        gestureRecognizerTargets.removeAll { target in
            guard target.gestureRecognizer === recognizer else { return false }
            recognizer.removeTarget(target, action: nil)
            return true
        }
    }

}
