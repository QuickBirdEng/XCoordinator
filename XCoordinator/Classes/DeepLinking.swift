//
//  DeepLinking.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public struct PresentationHandlerContext {
    internal var presentable: Presentable?

    internal static var empty: PresentationHandlerContext {
        return PresentationHandlerContext(presentable: nil)
    }
}

extension Coordinator where Self: AnyObject {
    public func deepLink<RootViewController>(_ route: RouteType, _ remainingRoutes: Route...) -> Transition<RootViewController> where TransitionType == Transition<RootViewController> {
        return .deepLink(with: self, route, array: remainingRoutes)
    }
}

extension Transition {
    public static func deepLink<C: Coordinator>(with coordinator: C, _ route: C.RouteType, _ remainingRoutes: Route...) -> Transition where C: AnyObject {
        return .deepLink(with: coordinator, route, array: remainingRoutes)
    }

    fileprivate static func deepLink<C: Coordinator>(with coordinator: C, _ route: C.RouteType,  array remainingRoutes: [Route]) -> Transition where C: AnyObject {
        return Transition(presentable: nil) { [weak coordinator] options, performer, completion in
            guard let coordinator = coordinator else {
                assertionFailure("Please use the coordinator responsible for executing a deepLink-Transition when initializing")
                return
            }

            guard let nextRoute = remainingRoutes.first else {
                completion?()
                return
            }

            nextRoute.trigger(on: nil, or: coordinator, remainingRoutes: remainingRoutes.dropFirst(), with: options, completion: completion)
        }
    }
}

extension Route {
    func trigger(on presentable: Presentable?, or alternativePresentable: Presentable, remainingRoutes: ArraySlice<Route>, with options: TransitionOptions, completion: PresentationHandler?) {
        guard let router = presentable?.router(for: self) ?? alternativePresentable.router(for: self) else {
            return assertionFailure("Could not find appropriate router for \(self). The following routes could not be triggered: \([self] + remainingRoutes).")
        }
        router.contextTrigger(self, with: options) { context in
            guard let nextRoute = remainingRoutes.first else {
                completion?()
                return
            }

            nextRoute.trigger(on: context.presentable, or: router, remainingRoutes: remainingRoutes.dropFirst(), with: options, completion: completion)
        }
    }
}
