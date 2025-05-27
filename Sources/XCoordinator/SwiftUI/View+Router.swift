//
//  View+Router.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 12.05.25.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, tvOS 13, *)
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

@available(iOS 13, tvOS 13, *)
extension View {
    
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

    public func router<RouteType: Route>(_ router: (any Router<RouteType>)?) -> some View {
        modifier(RouterModifier<RouteType>(router: router))
    }
    
}

#endif
