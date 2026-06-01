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
public typealias ContextPresentationHandler = (any TransitionContext) -> Void

///
/// Coordinator is the protocol every coordinator conforms to.
///
/// It owns a `rootViewController`, prepares a ``Transition`` for each triggered route via ``prepareTransition(for:)``,
/// and performs those transitions. Every transition is a `Transition<RootViewController>`; the concrete
/// root-view-controller type (e.g. `UINavigationController`) determines which transitions are available.
///
@MainActor
public protocol Coordinator<RouteType, RootViewController>: Router {

    /// The type of the rootViewController on which transitions are performed.
    associatedtype RootViewController: UIViewController

    /// The rootViewController on which transitions are performed.
    var rootViewController: RootViewController { get }

    ///
    /// This method prepares transitions for routes.
    /// It especially decides which transition is performed for a triggered route.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
    /// - Returns:
    ///     The prepared transition.
    ///
    @TransitionBuilder<RootViewController>
    func prepareTransition(for route: RouteType) -> Transition<RootViewController>

    ///
    /// Perform a transition.
    ///
    /// - Warning:
    ///     Do not use this method directly. Instead, trigger a route on your coordinator wherever possible.
    ///
    /// - Parameters:
    ///     - transition: The transition to be performed.
    ///     - options: The options on how to perform the transition, including the option to enable/disable animations.
    ///     - completion: The completion handler called once the transition has finished.
    ///
    func performTransition(_ transition: Transition<RootViewController>,
                           with options: TransitionOptions,
                           completion: PresentationHandler?)

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
    public func chain(routes: [RouteType]) -> Transition<RootViewController> {
        .multiple(routes.map(prepareTransition))
    }

    public func performTransition(_ transition: Transition<RootViewController>,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler? = nil) {
        #if canImport(SwiftUI)
        for presentable in transition.presentables {
            // The provider is usually the presentable's view controller (a `RoutingController`),
            // not the presentable (a coordinator) itself — so check both.
            if let provider = presentable as? RoutingContextProvider {
                provider.routingContext.add(self)
            } else if let viewController = presentable.viewController,
                      let provider = viewController as? RoutingContextProvider {
                provider.routingContext.add(self)
            }
        }
        #endif
        transition.perform(on: rootViewController, with: options) { [self] in
            removeChildrenIfNeeded()
            transition.presentables.forEach(addChild)
            completion?()
        }
    }

    ///
    /// Performs a transition described with the transition builder.
    ///
    /// - Warning:
    ///     Do not use this method directly. Instead, trigger a route on your coordinator wherever possible.
    ///
    /// - Parameters:
    ///     - options: The options on how to perform the transition. Defaults to animated.
    ///     - completion: The completion handler called once the transition has finished.
    ///     - transition: A transition-builder closure describing the transition to perform.
    ///
    public func performTransition(with options: TransitionOptions = TransitionOptions(animated: true),
                                  completion: PresentationHandler? = nil,
                                  @TransitionBuilder<RootViewController> _ transition: () -> Transition<RootViewController>) {
        performTransition(transition(), with: options, completion: completion)
    }
}
