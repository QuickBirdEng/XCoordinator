//
//  Coordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

/// The completion handler for transitions.
public typealias PresentationHandler = () -> Void

/// The completion handler for transitions, which also provides the context information about the transition.
public typealias ContextPresentationHandler = (TransitionContext) -> Void

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
    
    ///
    /// This method adds a child to a coordinator's children.
    ///
    /// - Parameter presentable:
    ///     The child to be added.
    ///
    func addChild(_ presentable: Presentable)
    
    ///
    /// This method removes a child to a coordinator's children.
    ///
    /// - Parameter presentable:
    ///     The child to be removed.
    ///
    func removeChild(_ presentable: Presentable)
    
    /// This method removes all children that are no longer in the view hierarchy.
    func removeChildrenIfNeeded()
}

// MARK: - Typealiases

extension Coordinator {

    /// Shortcut for Coordinator.TransitionType.RootViewController
    public typealias RootViewController = TransitionType.RootViewController
}

// MARK: - Presentable

extension Coordinator {

    /// A Coordinator uses its rootViewController as viewController.
    public var viewController: UIViewController! {
        rootViewController
    }
}

extension Coordinator where Self: Presentable & AnyObject {

    ///
    /// Creates a WeakRouter object from the given router to abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    /// The original router will be held weakly.
    ///
    public var weakRouter: WeakRouter<RouteType> {
        WeakRouter(self) { $0.strongRouter }
    }

    ///
    /// Creates an UnownedRouter object from the given router to abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    /// The original router will be held unowned.
    ///

    public var unownedRouter: UnownedRouter<RouteType> {
        UnownedRouter(self) { $0.strongRouter }
    }

}

// MARK: - Default implementations

extension Coordinator where Self: AnyObject {

    /// Creates an AnyCoordinator based on the current coordinator.
    public var anyCoordinator: AnyCoordinator<RouteType, TransitionType> {
        AnyCoordinator(self)
    }

    public func presented(from presentable: Presentable?) {}
    
    public func childTransitionCompleted() {
        removeChildrenIfNeeded()
    }

    public func contextTrigger(_ route: RouteType,
                               with options: TransitionOptions,
                               completion: ContextPresentationHandler?) {
        let transition = prepareTransition(for: route)
        performTransition(transition, with: options) { completion?(transition) }
    }

    ///
    /// With `chain(routes:)` different routes can be chained together to form a combined transition.
    ///
    /// - Parameter routes:
    ///     The routes to be chained.
    ///
    /// - Returns:
    ///     A transition combining the transitions of the specified routes.
    ///
    public func chain(routes: [RouteType]) -> TransitionType {
        .multiple(routes.map(prepareTransition))
    }

    public func performTransition(_ transition: TransitionType,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler? = nil) {
        transition.presentables.forEach(addChild)
        transition.perform(on: rootViewController, with: options) {
            completion?()
            self.removeChildrenIfNeeded()
        }
    }
}
