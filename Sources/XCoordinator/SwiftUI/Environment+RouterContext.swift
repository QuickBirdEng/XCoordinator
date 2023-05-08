//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import Foundation
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
private enum RouterContextKey: EnvironmentKey {

    static var defaultValue: RouterContext { .init() }

}

@available(iOS 13.0, tvOS 13.0, *)
extension EnvironmentValues {

    public var router: RouterContext {
        get { self[RouterContextKey.self] }
        set { self[RouterContextKey.self] = newValue }
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

    public var projectedValue: RouterContext {
        context
    }

    // MARK: Initialization

    public init(_ routeType: RouteType.Type) {}

}

#endif
