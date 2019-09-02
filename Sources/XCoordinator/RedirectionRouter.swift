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
/// Create a RedirectionRouter from a parent router by providing a reference to that parent.
/// Triggered routes of the RedirectionRouter will be redirected to this parent router according to the provided mapping.
/// Please provide either a `map` closure in the initializer or override the `mapToParentRoute` method.
///
/// A RedirectionRouter has a viewController which is used in transitions,
/// e.g. when you are presenting, pushing, or otherwise displaying it.
///
open class RedirectionRouter<ParentRoute: Route, RouteType: Route>: Router {

    // MARK: Stored properties

    /// A type-erased Router object of the parent router.
    public let parent: UnownedRouter<ParentRoute>

    private let _map: ((RouteType) -> ParentRoute)?

    // MARK: Computed properties

    ///
    /// The viewController used in transitions, e.g. when pushing, presenting
    /// or otherwise displaying the RedirectionRouter.
    ///
    public private(set) var viewController: UIViewController!

    // MARK: Initialization

    ///
    /// Creates a RedirectionRouter with a certain viewController, a parent router
    /// and an optional mapping.
    ///
    /// - Note:
    ///     Make sure to either override `mapToSuperRoute` or to specify a closure for the `map` parameter.
    ///     If you override `mapToSuperRoute`, the `map` parameter is ignored.
    ///
    /// - Parameters:
    ///     - viewController:
    ///         The view controller to be used in transitions, e.g. when pushing, presenting or otherwise displaying the RedirectionRouter.
    ///     - parent:
    ///         Triggered routes will be rerouted to the parent router.
    ///     - map:
    ///         A mapping from this RedirectionRouter's routes to the parent's routes.
    ///
    public init(viewController: UIViewController,
                parent: UnownedRouter<ParentRoute>,
                map: ((RouteType) -> ParentRoute)?) {
        self.parent = parent
        self._map = map
        self.viewController = viewController
    }

    // MARK: Methods

    open func contextTrigger(_ route: RouteType,
                             with options: TransitionOptions,
                             completion: ContextPresentationHandler?) {
        parent.contextTrigger(mapToParentRoute(route), with: options, completion: completion)
    }

    ///
    /// Map RouteType to ParentRoute.
    ///
    /// This method is called when a route is triggered in the RedirectionRouter.
    /// It is used to translate RouteType routes to the parent's routes which are then triggered in the parent router.
    ///
    /// - Parameter route:
    ///     The route to be mapped.
    ///
    /// - Returns:
    ///     The mapped route for the parent router.
    ///
    open func mapToParentRoute(_ route: RouteType) -> ParentRoute {
        guard let map = self._map else {
            fatalError("Please implement \(#function) or use the `map` closure in the initializer.")
        }
        return map(route)
    }
}
