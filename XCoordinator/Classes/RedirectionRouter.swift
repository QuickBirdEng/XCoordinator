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
    private weak var _viewController: UIViewController?

    // MARK: - Computed properties

    open var viewController: UIViewController! {
        if let vc = _viewController {
            return vc
        }

        let viewController = generateViewController()
        _viewController = viewController
        return viewController
    }

    // MARK: - Init

    public init(superRouter: AnyRouter<SuperRoute>, map: ((RouteType) -> SuperRoute)?) {
        self.superRouter = superRouter
        self._map = map
    }

    public convenience init<RouterType: Router>(viewController: UIViewController, superRouter: RouterType, map: ((RouteType) -> SuperRoute)?) where RouterType.RouteType == SuperRoute {
        self.init(superRouter: AnyRouter(superRouter), map: map)
    }

    // MARK: - Methods

    open func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        superRouter.contextTrigger(mapToSuperRoute(route), with: options, completion: completion)
    }

    open func mapToSuperRoute(_ route: RouteType) -> SuperRoute {
        guard let map = self._map else {
            fatalError("Please implement \(#function) or override this method.")
        }
        return map(route)
    }

    open func presented(from presentable: Presentable?) {
        viewController.presented(from: presentable)
    }

    open func generateViewController() -> UIViewController! {
        fatalError("Please override \(#function) to generate a viewController when needed.")
    }
}

extension RedirectionRouter {
    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return (anyRouter as? AnyRouter<R>) ?? (superRouter as? AnyRouter<R>)
    }
}
