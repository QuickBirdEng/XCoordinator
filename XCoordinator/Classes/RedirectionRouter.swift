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
    private let _viewController: ReferenceBox<UIViewController>

    // MARK: - Computed properties

    public var viewController: UIViewController! {
        return _viewController.get()
    }

    // MARK: - Init

    public init(viewController: UIViewController, superRouter: AnyRouter<SuperRoute>, map: ((RouteType) -> SuperRoute)?) {
        self.superRouter = superRouter
        self._map = map
        self._viewController = ReferenceBox(viewController)
    }

    public convenience init<RouterType: Router>(viewController: UIViewController, superRouter: RouterType, map: ((RouteType) -> SuperRoute)?) where RouterType.RouteType == SuperRoute {
        self.init(viewController: viewController, superRouter: AnyRouter(superRouter), map: map)
    }

    // MARK: - Methods

    public func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        superRouter.contextTrigger(mapToSuperRoute(route), with: options, completion: completion)
    }

    func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        superRouter.trigger(mapToSuperRoute(route), with: options, completion: completion)
    }

    func mapToSuperRoute(_ route: RouteType) -> SuperRoute {
        guard let map = self._map else {
            fatalError("Please implement \(#function) or override this method.")
        }
        return map(route)
    }

    public func presented(from presentable: Presentable?) {
        _viewController.releaseStrongReference()
    }
}

extension RedirectionRouter {
    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return (anyRouter as? AnyRouter<R>) ?? (superRouter as? AnyRouter<R>)
    }
}
