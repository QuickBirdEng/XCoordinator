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
public typealias ContextPresentationHandler = (any TransitionProtocol) -> Void

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
    func addChild(_ presentable: any Presentable)
    
    ///
    /// This method removes a child to a coordinator's children.
    ///
    /// - Parameter presentable:
    ///     The child to be removed.
    ///
    func removeChild(_ presentable: any Presentable)
    
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

// MARK: - Default implementations

extension Coordinator where Self: AnyObject {

    public func presented(from presentable: (any Presentable)?) {}
    
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
        #if canImport(SwiftUI)
        if #available(iOS 13.0, tvOS 13.0, *) {
            for presentable in transition.presentables {
                (presentable as? RouterContextReplacable)?.replaceContext(with: self)
            }
        }
        #endif
        transition.perform(on: rootViewController, with: options) { [self] in
            transition.presentables.forEach(addChild)
            removeChildrenIfNeeded()
            completion?()
        }
    }
}
