//
//  RedirectionRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// RedirectionRouters can be used to extract routes into different route types.
/// Instead of having one huge route and one or more huge coordinators, you can create separate redirecting routers.
///
/// Create a RedirectionRouter from a superCoordinator by providing a reference to the superCoordinator.
/// Triggered routes of the RedirectionRouter will be redirected to this superCoordinator according to the provided mapping.
/// Please provide either a `map` closure in the initializer or override the `mapToSuperRoute` method.
///
/// A RedirectionRouter has a viewController which is used in transitions,
/// e.g. when you are presenting, pushing, or otherwise displaying it.
///
open class RedirectionRouter<SuperRoute: Route, RouteType: Route>: Router {

    // MARK: Stored properties

    /// A type-erased Router object of the superCoordinator.
    public let superRouter: UnownedRouter<SuperRoute>

    private let _map: ((RouteType) -> SuperRoute)?

    // MARK: Computed properties

    ///
    /// The viewController used in transitions, e.g. when pushing, presenting
    /// or otherwise displaying the RedirectionRouter.
    ///
    public private(set) var viewController: UIViewController!

    // MARK: Initialization

    ///
    /// Creates a RedirectionRouter with a certain viewController, a superRouter and an optional mapping.
    ///
    /// - Note:
    ///     Make sure to either override `mapToSuperRoute` or to specify a closure for the `map` parameter.
    ///     If you override `mapToSuperRoute`, the `map` parameter is ignored.
    ///
    /// - Parameters:
    ///     - viewController:
    ///         The view controller to be used in transitions, e.g. when pushing, presenting or otherwise displaying the RedirectionRouter.
    ///     - superRouter:
    ///         Triggered routes will be rerouted to the superRouter.
    ///     - map:
    ///         A mapping from this RedirectionRouter's routes to the superRouter's routes.
    ///
    public init(viewController: UIViewController,
                superRouter: UnownedRouter<SuperRoute>,
                map: ((RouteType) -> SuperRoute)?) {
        self.superRouter = superRouter
        self._map = map
        self.viewController = viewController
    }

    // MARK: Methods

    open func contextTrigger(_ route: RouteType,
                             with options: TransitionOptions,
                             completion: ContextPresentationHandler?) {
        superRouter.contextTrigger(mapToSuperRoute(route), with: options, completion: completion)
    }

    ///
    /// Map RouteType to SuperRoute.
    ///
    /// This method is called when a route is triggered in the RedirectionRouter.
    /// It is used to translate RouteType routes to the superRouter's routes which are then triggered in the superRouter.
    ///
    /// - Parameter route:
    ///     The route to be mapped.
    ///
    /// - Returns:
    ///     The mapped route for the superRouter.
    ///
    open func mapToSuperRoute(_ route: RouteType) -> SuperRoute {
        guard let map = self._map else {
            fatalError("Please implement \(#function) or use the `map` closure in the initializer.")
        }
        return map(route)
    }
}
