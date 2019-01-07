//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// The Router protocol is used to abstract away from the transition-type specific characteristics of a Coordinator.
///
/// A Router can trigger routes, which lead to transitions being executed. In constrast to the Coordinator protocol,
/// the router does not specify a TransitionType and can therefore be used in the form of an AnyRouter to reduce a coordinator's
/// capabilities to the triggering of routes. This may especially be useful in viewModels when using them in different contexts.
///
public protocol Router: Presentable {

    /// RouteType defines which routes can be triggered in a certain Router implementation.
    associatedtype RouteType: Route

    ///
    /// Triggers routes and returns context in completion-handler.
    ///
    /// Useful for deep linking. It is encouraged to use `trigger` instead, if the context is not needed.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options configuring the execution of transitions, e.g. whether it should be animated.
    ///
    /// - Parameter completion:
    ///     Optional completion handler. If present, it is executed once the transition is completed (including animations).
    ///     If the context is not needed, use `trigger` instead.
    ///
    func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?)
}

extension Router {

    // MARK: - Convenience methods

    ///
    /// Triggers the specified route without the need of specifying a completion handler.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options for performing the transition, e.g. whether it should be animated.
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions) {
        trigger(route, with: options, completion: nil)
    }

    ///
    /// Triggers the specified route without the need of specifying transition options.
    /// Instead default transition options are used, which allow the animation of the transition.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter completion:
    ///     Optional completion handler. If present, it is executed once the transition is completed (including animations).
    ///
    public func trigger(_ route: RouteType, completion: PresentationHandler? = nil) {
        trigger(route, with: .default, completion: completion)
    }

    ///
    /// Triggers the specified route by performing a transition.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options for performing the transition, e.g. whether it should be animated.
    ///
    /// - Parameter completion:
    ///     Optional completion handler. If present, it is executed once the transition is completed (including animations).
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        contextTrigger(route, with: options) { _ in completion?() }
    }
}

extension Router where Self: Presentable {

    // MARK: - Computed properties

    ///
    /// Creates an AnyRouter object from the given router to abstract away from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    ///
    public var anyRouter: AnyRouter<RouteType> {
        return AnyRouter(self)
    }

    ///
    /// Returns a router for the specified route, if possible.
    ///
    /// - Parameter route:
    ///     The route to return an AnyRouter for.
    ///
    /// - Returns:
    ///     It returns `nil`, if the route is not of type `Router.RouteType`, otherwise it returns its anyRouter.
    ///
    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return anyRouter as? AnyRouter<R>
    }
}
