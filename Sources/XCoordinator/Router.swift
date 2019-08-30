//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// The Router protocol is used to abstract the transition-type specific characteristics of a Coordinator.
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

    // MARK: - Convenience methods

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
        contextTrigger(route, with: options) { _ in completion?() }
    }
}

extension Coordinator where Self: AnyObject & Presentable {

    ///
    /// Use `strongRouter`, `unownedRouter` or `weakRouter` instead.
    ///
    /// To help you choose between router types, ask the following question:
    ///
    /// Will there be a reference from the view hierarchy to this router?
    ///
    /// Yes (e.g. viewController or viewModel)
    ///     - Use `unownedRouter` or `weakRouter`.
    ///
    /// No (e.g. parent/child coordinator)
    ///     - Use `strongRouter` for references to child coordinators.
    ///     - Use `unownedRouter` or `weakRouter` for references to parent and sibling coordinators. 
    ///
    @available(iOS, deprecated, message: "Use `strongRouter`, `unownedRouter` or `weakRouter` instead.")
    public var anyRouter: AnyRouter<RouteType> {
        return unownedRouter
    }

    ///
    /// Creates a StrongRouter object from the given router to abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    ///
    /// It further holds a strong reference to the original coordinator.
    ///
    /// - Note:
    ///     Do not use this in any view controller!
    ///     Keeping a strong reference to the coordinator results in memory cycles.
    ///     Use `unownedRouter` or `weakRouter` instead for use in the view hierarchy.
    ///
    public var strongRouter: StrongRouter<RouteType> {
        return StrongRouter(self)
    }

    ///
    /// Creates an WeakRouter object from the given router to abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    ///
    /// It further holds a weak reference to the original coordinator.
    /// If you need a strong reference to the original object, use `strongRouter` instead.
    ///
    /// - Note:
    ///     If you call functions from the Router protocol on this object,
    ///     it might not get called, when the original object was already deallocated.
    ///
    public var weakRouter: WeakRouter<RouteType> {
        return WeakRouter(self) { $0.strongRouter }
    }

    ///
    /// Creates an UnownedRouter object from the given router to
    /// abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    ///
    /// It further holds an unowned reference to the original coordinator.
    /// If you need a strong reference to the original object, use `strongRouter` instead.
    ///
    public var unownedRouter: UnownedRouter<RouteType> {
        return UnownedRouter(self) { $0.strongRouter }
    }
    
}

extension Router where Self: Presentable {

    ///
    /// Returns a router for the specified route, if possible.
    ///
    /// - Parameter route:
    ///     The route to return an AnyRouter for.
    ///
    /// - Returns:
    ///     It returns the router's anyRouter, if it is compatible with the given route, otherwise `nil`.
    ///
    public func router<R: Route>(for route: R.Type) -> StrongRouter<R>? {
        return StrongRouter<RouteType>(self) as? StrongRouter<R>
    }
}
