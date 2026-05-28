//
//  RoutingContext.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

///
/// A registry of `Router` instances keyed by their `Route` type, propagated through the SwiftUI environment.
///
/// `RoutingContext` carries one router per route type so that `@Routing<SomeRoute>` can resolve the
/// appropriate router for any flow currently in scope. It is propagated two ways simultaneously:
///
/// - **Down** through `EnvironmentValues.routingContext`, so descendants can read the available routers.
/// - **Up** through a `SwiftUI.PreferenceKey`, so hosts (e.g. ``RoutingController``) can observe routers
///   registered deeper in the view tree and merge them back into their own context.
///
@MainActor
public struct RoutingContext: Equatable {

    // MARK: Static Functions

    /// Two routing contexts are considered equal when they contain the same router instances
    /// (compared by `ObjectIdentifier`) keyed by the same route types.
    public static func == (lhs: RoutingContext, rhs: RoutingContext) -> Bool {
        return lhs.routers.mapValues { ObjectIdentifier($0) } == rhs.routers.mapValues { ObjectIdentifier($0) }
    }

    // MARK: Nested Types

    @MainActor
    fileprivate enum EnvironmentKey: SwiftUI.EnvironmentKey {
        static var defaultValue: RoutingContext { RoutingContext() }
    }

    @MainActor
    fileprivate enum PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: RoutingContext { RoutingContext() }

        static func reduce(value: inout RoutingContext, nextValue: () -> RoutingContext) {
            value.add(nextValue())
        }
    }

    // MARK: Properties

    private var routers = [ObjectIdentifier: any Router]()

    // MARK: Initialization

    /// Creates an empty routing context.
    public nonisolated init() {}

    /// Creates a routing context pre-populated with the given routers.
    ///
    /// - Parameter routers: Routers to register. Each is keyed by its concrete `RouteType`.
    public init(_ routers: [any Router] = []) {
        for router in routers {
            add(router)
        }
    }

    // MARK: Subscripts

    /// Reads or writes the router responsible for the given route type.
    public subscript<R: Route>(_ routeType: R.Type) -> (any Router<R>)? {
        get { routers[ObjectIdentifier(routeType)]?.router(for: routeType) }
        set { routers[ObjectIdentifier(routeType)] = newValue }
    }

    // MARK: Methods

    /// Registers a router under its declared `RouteType`. Replaces any existing router for that type.
    public mutating func add(_ router: any Router) {
        router.add(to: &self)
    }

    private mutating func add(_ context: RoutingContext) {
        for (key, value) in context.routers {
            routers[key] = value
        }
    }

}

extension Router {
    @MainActor
    fileprivate func add(to context: inout RoutingContext) {
        context[RouteType.self] = self
    }
}

extension View {
    internal func onRoutingContextChanged(perform: @escaping (RoutingContext) -> Void) -> some View {
        onPreferenceChange(RoutingContext.PreferenceKey.self) {
            perform($0)
        }
    }

    internal func routingContext(_ context: RoutingContext) -> some View {
        preference(key: RoutingContext.PreferenceKey.self, value: context)
    }
}

extension EnvironmentValues {
    internal var routingContext: RoutingContext {
        get { self[RoutingContext.EnvironmentKey.self] }
        set { self[RoutingContext.EnvironmentKey.self] = newValue }
    }
}

#endif
