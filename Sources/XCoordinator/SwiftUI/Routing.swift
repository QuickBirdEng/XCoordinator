//
//  Routing.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@MainActor
@available(iOS 13, tvOS 13, *)
@propertyWrapper
public struct Routing<RouteType: Route>: DynamicProperty {

    // MARK: Stored Properties

    @Environment(\.routingContext) private var routingContext

    // MARK: Computed Properties

    public var wrappedValue: any Router<RouteType> {
        guard let router = routingContext[RouteType.self] else {
            fatalError("""
            The current environment does not contain a router with the route type of \"\(RouteType.self)\".
            Please make sure to specify the correct route type when using this property wrapper.
            """)
        }
        return router
    }

    public var projectedValue: RoutingContext {
        routingContext
    }

    // MARK: Initialization

    public init(_ routeType: RouteType.Type = RouteType.self) {}

    // MARK: Methods

    public func router<R: Route>(for: R.Type) -> (any Router<R>)? {
        routingContext[R.self]
    }
    
}

#endif
