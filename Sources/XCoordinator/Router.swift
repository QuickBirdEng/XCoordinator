//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

///
/// The Router protocol is used to abstract the transition-type specific characteristics of a Coordinator.
///
/// A Router can trigger routes, which lead to transitions being executed. In constrast to the Coordinator protocol,
/// the router does not specify a TransitionType and can therefore be used in the form of a
/// `StrongRouter`, `UnownedRouter` or `WeakRouter` to reduce a coordinator's capabilities to
/// the triggering of routes.
/// This may especially be useful in viewModels when using them in different contexts.
///
public protocol Router: Presentable {

    /// RouteType defines which routes can be triggered in a certain Router implementation.
    associatedtype RouteType: Route

    ///
    /// Triggers routes and returns context in completion-handler.
    ///
    /// Useful for deep linking. It is encouraged to use `trigger` instead, if the context is not needed.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options:
    ///         Transition options configuring the execution of transitions, e.g. whether it should be animated.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///         If the context is not needed, use `trigger` instead.
    ///
    func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?)
}

extension Router {

    // MARK: Convenience methods

    ///
    /// Triggers the specified route without the need of specifying a completion handler.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options:
    ///         Transition options for performing the transition, e.g. whether it should be animated.
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions) {
        trigger(route, with: options, completion: nil)
    }

    ///
    /// Triggers the specified route with default transition options enabling the animation of the transition.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///
    public func trigger(_ route: RouteType, completion: PresentationHandler? = nil) {
        trigger(route, with: .default, completion: completion)
    }

    ///
    /// Triggers the specified route by performing a transition.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options: Transition options for performing the transition, e.g. whether it should be animated.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        autoreleasepool {
            contextTrigger(route, with: options) { _ in completion?() }
        }
    }
}

extension Router where Self: Presentable {

    // MARK: Computed properties

    ///
    /// Creates a StrongRouter object from the given router to abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    /// The original router will be held strongly.
    ///
    public var strongRouter: StrongRouter<RouteType> {
        StrongRouter(self)
    }

    ///
    /// Returns a router for the specified route, if possible.
    ///
    /// - Parameter route:
    ///     The route type to return a router for.
    ///
    /// - Returns:
    ///     It returns the router's strongRouter,
    ///     if it is compatible with the given route type,
    ///     otherwise `nil`.
    ///
    public func router<R: Route>(for route: R) -> StrongRouter<R>? {
        strongRouter as? StrongRouter<R>
    }
}
