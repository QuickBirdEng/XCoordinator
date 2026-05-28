//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

///
/// The Router protocol abstracts a coordinator down to its route-triggering capability.
///
/// In contrast to ``Coordinator``, `Router` does not specify a `TransitionType` and can therefore be
/// used as `any Router<RouteType>` to expose only the trigger surface to view models and views.
/// Pair the existential with the ARC qualifier that matches the relationship — `unowned`/`weak` for
/// child holding parent, `strong` for ownership.
///
@MainActor
public protocol Router<RouteType>: Presentable, AnyObject {

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

extension Router {

    ///
    /// Triggers the specified route with default transition options enabling the animation of the transition.
    ///
    /// Suspends until the underlying transition has completed (including any animations).
    ///
    /// - Parameter route: The route to be triggered.
    ///
    @MainActor public func trigger(_ route: RouteType) async {
        await trigger(route, with: .default)
    }

    ///
    /// Triggers the specified route by performing a transition.
    ///
    /// Suspends until the underlying transition has completed (including any animations).
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options: Transition options for performing the transition, e.g. whether it should be animated.
    ///
    @MainActor public func trigger(_ route: RouteType, with options: TransitionOptions) async {
        _ = await contextTrigger(route, with: options)
    }

    ///
    /// Triggers a route and returns the resulting transition context.
    ///
    /// Useful for deep linking. Prefer ``trigger(_:with:)`` if the context is not needed.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options: Transition options configuring the execution of transitions, e.g. whether it should be animated.
    ///
    /// - Returns: The transition context of the performed transition(s).
    ///
    @MainActor public func contextTrigger(_ route: RouteType, with options: TransitionOptions) async -> any TransitionProtocol {
        await withCheckedContinuation { continuation in
            contextTrigger(route, with: options) { context in
                continuation.resume(returning: context)
            }
        }
    }

}
