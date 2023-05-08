//
//  Routing.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
@propertyWrapper
public struct Routing<RouteType: Route>: DynamicProperty {

    // MARK: Stored Properties

    @Environment(\.routingContext) private var context

    // MARK: Computed Properties

    public var wrappedValue: any Router<RouteType> {
        guard let router = context.router(for: RouteType.self) else {
            fatalError("""
            The current environment does not contain a router with the route type of \"\(RouteType.self)\".
            Please make sure to specify the correct route type when using this property wrapper.
            """)
        }
        return router
    }

    public var projectedValue: (any Router<RouteType>)? {
        context.router(for: RouteType.self)
    }

    // MARK: Initialization

    public init(_ routeType: RouteType.Type) {}

    // MARK: Methods

    public func router<R: Route>(for: R.Type) -> (any Router<R>)? {
        context.router(for: R.self)
    }

}

#endif
