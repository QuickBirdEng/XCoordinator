//
//  Coordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

/// The completion handler for transitions.
public typealias PresentationHandler = () -> Void

/// The completion handler for transitions, which also provides the context information about the transition.
public typealias ContextPresentationHandler = (PresentationHandlerContext) -> Void

///
/// Coordinator is the protocol every coordinator conforms to.
///
/// It requires an object to be able to trigger routes and perform transitions.
/// This connection is created using the `prepareTransition(for:)` method.
///
public protocol Coordinator: Router, TransitionPerformer {

    ///
    /// This method prepares transitions for routes.
    /// It especially decides, which transitions are performed for the triggered routes.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
    /// - Returns:
    ///     The prepared transition.
    ///
    func prepareTransition(for route: RouteType) -> TransitionType
}

// MARK: - Typealiases

extension Coordinator {

    /// Shortcut for Coordinator.TransitionType.RootViewController
    public typealias RootViewController = TransitionType.RootViewController
}

// MARK: - Presentable

extension Coordinator {

    /// A Coordinator uses its rootViewController as viewController, with the exception `RedirectionCoordinator`.
    public var viewController: UIViewController! {
        return rootViewController
    }
}

// MARK: - Default implementations

extension Coordinator {

    /// Creates an AnyCoordinator based on the current coordinator.
    public var anyCoordinator: AnyCoordinator<RouteType, TransitionType> {
        return AnyCoordinator(self)
    }

    public func presented(from presentable: Presentable?) {}

    public func contextTrigger(_ route: RouteType,
                               with options: TransitionOptions,
                               completion: ContextPresentationHandler?) {
        let transition = prepareTransition(for: route)
        let context = PresentationHandlerContext(presentables: transition.presentables)
        performTransition(transition, with: options) { completion?(context) }
    }

    ///
    /// With `chain(routes:)` you can chain different routes to form a combined transition.
    ///
    /// - Parameter routes:
    ///     The routes to be chained.
    ///
    /// - Returns:
    ///     A transition combining the transitions of the specified routes.
    ///
    public func chain(routes: [RouteType]) -> TransitionType {
        return .multiple(routes.map(prepareTransition))
    }

    public func performTransition(_ transition: TransitionType,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler? = nil) {
        transition.perform(options: options, coordinator: self, completion: completion)
    }
}
