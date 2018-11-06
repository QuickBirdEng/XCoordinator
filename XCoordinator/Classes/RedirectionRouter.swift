//
//  RedirectionRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

// OPEN FOR DISCUSSION - Reason for being internal

class RedirectionRouter<SuperRoute: Route, RouteType: Route>: Router {

    // MARK: - Stored properties

    let map: ((RouteType) -> SuperRoute)?
    let superRouter: AnyRouter<SuperRoute>

    // MARK: - Computed properties

    var viewController: UIViewController! {
        return superRouter.viewController
    }

    // MARK: - Init

    init(superRouter: AnyRouter<SuperRoute>, map: ((RouteType) -> SuperRoute)?) {
        self.superRouter = superRouter
        self.map = map
    }

    convenience init<RouterType: Router>(superRouter: RouterType, map: ((RouteType) -> SuperRoute)?) where RouterType.RouteType == SuperRoute {
        self.init(superRouter: AnyRouter(superRouter), map: map)
    }

    // MARK: - Methods

    func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        superRouter.contextTrigger(mapToSuperRoute(route), with: options, completion: completion)
    }

    func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        superRouter.trigger(mapToSuperRoute(route), with: options, completion: completion)
    }

    func mapToSuperRoute(_ route: RouteType) -> SuperRoute {
        guard let map = self.map else {
            fatalError("Please implement \(#function) or override this method.")
        }
        return map(route)
    }

    func presented(from presentable: Presentable?) {
        superRouter.presented(from: presentable)
    }
}

extension RedirectionRouter {
    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return (anyRouter as? AnyRouter<R>) ?? (superRouter as? AnyRouter<R>)
    }
}
