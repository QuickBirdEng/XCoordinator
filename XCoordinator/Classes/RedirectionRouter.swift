//
//  RedirectionRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

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

    // MARK: - Stored properties

    /// An AnyRouter object of the superCoordinator.
    public let superRouter: AnyRouter<SuperRoute>

    private let _map: ((RouteType) -> SuperRoute)?
    private let viewControllerBox: ReferenceBox<UIViewController>

    // MARK: - Computed properties

    /// The viewController used in transitions, e.g. when pushing, presenting or otherwise displaying the RedirectionRouter.
    public var viewController: UIViewController! {
        return viewControllerBox.get()
    }

    // MARK: - Initialization

    ///
    /// Creates a RedirectionRouter with a certain viewController, a superRouter and an optional mapping.
    ///
    /// - Parameter viewController:
    ///     The view controller to be used in transitions, e.g. when pushing, presenting or otherwise displaying the RedirectionRouter.
    ///
    /// - Parameter superRouter:
    ///     An AnyRouter object of the superCoordinator. Triggered routes will be rerouted there.
    ///
    /// - Parameter map:
    ///     A mapping from this RedirectionRouter's routes to the superRouter's routes.
    ///     If you specify `nil` here, make sure to override `mapToSuperRoute`.
    ///     If you specify a closure, but also override `mapToSuperRoute`, the closure is ignored.
    ///
    public init(viewController: UIViewController,
                superRouter: AnyRouter<SuperRoute>,
                map: ((RouteType) -> SuperRoute)?) {
        self.superRouter = superRouter
        self._map = map
        self.viewControllerBox = ReferenceBox(viewController)
    }

    ///
    /// Creates a RedirectionRouter with a certain viewController, a superRouter and an optional mapping.
    ///
    /// - Parameter viewController:
    ///     The view controller to be used in transitions, e.g. when pushing, presenting or otherwise displaying the RedirectionRouter.
    ///
    /// - Parameter superRouter:
    ///     The superCoordinator. Triggered routes will be rerouted there.
    ///
    /// - Parameter map:
    ///     A mapping from this RedirectionRouter's routes to the superRouter's routes.
    ///     If you specify `nil` here, make sure to override `mapToSuperRoute`.
    ///     If you specify a closure, but also override `mapToSuperRoute`, the closure is ignored.
    ///
    public init<RouterType: Router>(viewController: UIViewController,
                                    superRouter: RouterType,
                                    map: ((RouteType) -> SuperRoute)?) where RouterType.RouteType == SuperRoute {
        self.superRouter = AnyRouter(superRouter)
        self._map = map
        self.viewControllerBox = ReferenceBox(viewController)
    }

    // MARK: - Methods

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

    open func presented(from presentable: Presentable?) {
        viewController.presented(from: presentable)
        DispatchQueue.main.async {
            self.viewControllerBox.releaseStrongReference()
        }
    }
}

extension RedirectionRouter {
    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return (anyRouter as? AnyRouter<R>) ?? (superRouter as? AnyRouter<R>)
    }
}
