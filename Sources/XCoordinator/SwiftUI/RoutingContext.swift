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
public struct RoutingContext: Equatable {

    // MARK: Static Functions

    /// Two routing contexts are considered equal when they contain the same router instances
    /// (compared by `ObjectIdentifier`) keyed by the same route types. Deallocated routers compare
    /// as `nil`, so a context whose router has gone away is no longer equal to one that still holds it.
    public static func == (lhs: RoutingContext, rhs: RoutingContext) -> Bool {
        return lhs.routers.mapValues { $0.router.map(ObjectIdentifier.init) }
            == rhs.routers.mapValues { $0.router.map(ObjectIdentifier.init) }
    }

    // MARK: Nested Types

    /// Holds a router weakly so that a `RoutingContext` does not keep routers alive. Every router
    /// registered here is owned elsewhere (a parent coordinator's `children`, `WrappedRouter.Holder`,
    /// or a `RouterModifier`), so a strong reference would only create retain cycles.
    private struct WeakRouter {
        weak var router: (any Router)?
    }

    fileprivate enum EnvironmentKey: SwiftUI.EnvironmentKey {
        static var defaultValue: RoutingContext { RoutingContext() }
    }

    fileprivate enum PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: RoutingContext { RoutingContext() }

        static func reduce(value: inout RoutingContext, nextValue: () -> RoutingContext) {
            value.add(nextValue())
        }
    }

    // MARK: Properties

    private var routers = [ObjectIdentifier: WeakRouter]()

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
    ///
    /// Each router is stored keyed by its own `RouteType`, so casting the stored router to
    /// `any Router<R>` for that same key is equivalent to `router(for:)` — and avoids calling the
    /// main-actor-isolated `router(for:)`, keeping this type free of actor isolation.
    public subscript<R: Route>(_ routeType: R.Type) -> (any Router<R>)? {
        get { routers[ObjectIdentifier(routeType)]?.router as? any Router<R> }
        set {
            if let newValue {
                routers[ObjectIdentifier(routeType)] = WeakRouter(router: newValue)
            } else {
                routers[ObjectIdentifier(routeType)] = nil
            }
        }
    }

    // MARK: Methods

    /// Registers a router under its declared `RouteType`. Replaces any existing router for that type.
    public mutating func add(_ router: any Router) {
        router.add(to: &self)
    }

    internal mutating func add(_ context: RoutingContext) {
        for (key, value) in context.routers {
            routers[key] = value
        }
    }

}

extension Router {
    // `nonisolated` overrides the `@MainActor` isolation inherited from the `Router` protocol: this only
    // stores a reference via the (nonisolated) subscript setter, so it needs no actor isolation and keeps
    // `RoutingContext` free of `@MainActor`.
    fileprivate nonisolated func add(to context: inout RoutingContext) {
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
