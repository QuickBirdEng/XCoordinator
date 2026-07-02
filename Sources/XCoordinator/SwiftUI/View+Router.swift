//
//  View+Router.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 12.05.25.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

private struct RouterModifier<RouteType: Route>: ViewModifier {

    // MARK: Properties

    let router: (any Router)?

    // MARK: Methods

    func body(content: Content) -> some View {
        content
            .transformEnvironment(\EnvironmentValues.routingContext) { context in
                context[RouteType.self] = router?.router(for: RouteType.self)
            }
    }

}

extension View {

    ///
    /// Wraps the view in a ``RedirectionRouter`` that maps a new child route type onto an existing parent router.
    ///
    /// Use this when a SwiftUI subtree should expose its own `Route` enum but ultimately delegate
    /// transitions to a UIKit-backed parent coordinator. Triggering a `ChildRoute` from inside the view
    /// (via `@Routing<ChildRoute>`) calls `map` to obtain a `ParentRoute` and triggers it on `parent`.
    ///
    /// - Parameters:
    ///   - routeType: The child route type. Defaults to inference from the closure signature.
    ///   - parent: The parent router that ultimately performs transitions.
    ///   - map: A closure mapping each `ChildRoute` to a `ParentRoute`.
    /// - Returns: A view that exposes a ``RedirectionRouter`` for `ChildRoute` in its environment.
    ///
    public func redirect<ParentRoute: Route, ChildRoute: Route>(
        _ routeType: ChildRoute.Type = ChildRoute.self,
        to parent: any Router<ParentRoute>,
        map: @escaping (ChildRoute) -> ParentRoute
    ) -> some View {
        WrappedRouter {
            let viewController = RoutingController(rootView: self)
            let router = RedirectionRouter(
                viewController: viewController,
                parent: parent,
                map: map
            )
            viewController.routingContext.add(router)
            return router
        }
    }

    ///
    /// Registers (or overrides) the router for `RouteType` in this view's environment.
    ///
    /// Use this to inject a router into a SwiftUI subtree so that descendants can resolve it via
    /// `@Routing<RouteType>`. Passing `nil` removes the router for `RouteType` from the environment.
    ///
    /// - Parameter router: The router to inject, or `nil` to remove it.
    /// - Returns: A view whose environment contains the given router for `RouteType`.
    ///
    public func router<RouteType: Route>(_ router: (any Router<RouteType>)?) -> some View {
        modifier(RouterModifier<RouteType>(router: router))
    }

}

#endif
