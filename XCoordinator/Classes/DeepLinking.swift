//
//  DeepLinking.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public struct PresentationHandlerContext {
    internal let presentables: [Presentable]

    internal static let empty = PresentationHandlerContext(presentables: [])
}

// MARK: - Coordinator + DeepLinking

extension Coordinator where Self: AnyObject {
    public func deepLink<RootViewController, S: Sequence>(_ route: RouteType, _ remainingRoutes: S)
        -> Transition<RootViewController> where S.Element == Route, TransitionType == Transition<RootViewController> {
        return .deepLink(with: self, route, array: Array(remainingRoutes))
    }

    public func deepLink<RootViewController>(_ route: RouteType, _ remainingRoutes: Route...)
        -> Transition<RootViewController> where TransitionType == Transition<RootViewController> {
        return .deepLink(with: self, route, array: remainingRoutes)
    }
}

// MARK: - Transition + DeepLink

extension Transition {
    fileprivate static func deepLink<C: Coordinator & AnyObject>(with coordinator: C,
                                                                 _ route: C.RouteType,
                                                                 array remainingRoutes: [Route]) -> Transition {

        return Transition(presentables: [], animation: nil) { [weak coordinator] options, _, completion in
            guard let coordinator = coordinator else {
                assertionFailure("Please use the coordinator responsible for executing a deepLink-Transition when initializing.")
                completion?()
                return
            }

            route.trigger(on: [coordinator], remainingRoutes: ArraySlice(remainingRoutes),
                          with: options, completion: completion)
        }
    }
}

// MARK: - Route + DeepLink

extension Route {
    private func router(fromStack stack: inout [Presentable]) -> AnyRouter<Self>? {
        while !stack.isEmpty {
            if let router = stack.last?.router(for: self) {
                return router
            }
            stack.removeLast()
        }
        return nil
    }

    fileprivate func trigger(on presentables: [Presentable],
                             remainingRoutes: ArraySlice<Route>,
                             with options: TransitionOptions,
                             completion: PresentationHandler?) {
        var stack = presentables

        guard let router = router(fromStack: &stack) else {
            // swiftlint:disable:next line_length
            assertionFailure("Could not find appropriate router for \(self). The following routes could not be triggered: \([self] + remainingRoutes).")
            completion?()
            return
        }

        router.contextTrigger(self, with: options) { context in
            guard let nextRoute = remainingRoutes.first else {
                completion?()
                return
            }

            stack.append(contentsOf: context.presentables)
            nextRoute.trigger(on: stack, remainingRoutes: remainingRoutes.dropFirst(),
                              with: options, completion: completion)
        }
    }
}
