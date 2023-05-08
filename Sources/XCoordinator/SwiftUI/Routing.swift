//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
private enum RoutingContextKey: EnvironmentKey {

    static var defaultValue: RoutingContext { .init() }

}

@available(iOS 13.0, tvOS 13.0, *)
extension EnvironmentValues {

    internal var router: RoutingContext {
        get { self[RoutingContextKey.self] }
        set { self[RoutingContextKey.self] = newValue }
    }

}

@available(iOS 13.0, tvOS 13.0, *)
@propertyWrapper
public struct Routing<RouteType: Route>: DynamicProperty {

    // MARK: Stored Properties

    @Environment(\.router) private var context

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

    public func router<RouteType: Route>(for: RouteType.Type) -> (any Router<RouteType>)? {
        context.router(for: RouteType.self)
    }

    // MARK: Initialization

    public init(_ routeType: RouteType.Type) {}

}

#endif
