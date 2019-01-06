//
//  RedirectionRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class RedirectionRouter<SuperRoute: Route, RouteType: Route>: Router {

    // MARK: - Stored properties

    public let superRouter: AnyRouter<SuperRoute>

    private let _map: ((RouteType) -> SuperRoute)?
    private let viewControllerBox: ReferenceBox<UIViewController>

    // MARK: - Computed properties

    public var viewController: UIViewController! {
        return viewControllerBox.get()
    }

    // MARK: - Init

    public init(viewController: UIViewController,
                superRouter: AnyRouter<SuperRoute>,
                map: ((RouteType) -> SuperRoute)?) {
        self.superRouter = superRouter
        self._map = map
        self.viewControllerBox = ReferenceBox(viewController)
    }

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
