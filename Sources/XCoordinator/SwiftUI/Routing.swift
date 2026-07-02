//
//  Routing.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

///
/// A property wrapper that resolves the nearest `Router` for a given `Route` type from the SwiftUI environment.
///
/// Use `@Routing` inside a SwiftUI view to access the router responsible for a particular flow.
/// The wrapped value is non-optional — if no matching router is in scope, accessing it triggers a `fatalError`,
/// because that is a programmer error rather than a runtime condition.
///
/// ```swift
/// struct ChildView: View {
///     @Routing<UsersRoute> var usersRouter
///
///     var body: some View {
///         Button("Open") { usersRouter.trigger(.user("Bob")) }
///     }
/// }
/// ```
///
/// The projected value exposes the full ``RoutingContext`` for advanced lookups via `$router[OtherRoute.self]`.
///
@MainActor
@propertyWrapper
public struct Routing<RouteType: Route>: DynamicProperty {

    // MARK: Stored Properties

    @Environment(\.routingContext) private var routingContext

    // MARK: Computed Properties

    /// The router responsible for `RouteType` in the current environment.
    ///
    /// - Important: Triggers `fatalError` if no router for `RouteType` was registered upstream. Make sure
    ///   the view is hosted within a ``RoutingController``, ``WrappedRouter``, or a `View.router(_:)` modifier
    ///   that provides a matching router.
    public var wrappedValue: any Router<RouteType> {
        guard let router = routingContext[RouteType.self] else {
            fatalError("""
            The current environment does not contain a router with the route type of \"\(RouteType.self)\".
            Please make sure to specify the correct route type when using this property wrapper.
            """)
        }
        return router
    }

    /// The full ``RoutingContext``, allowing access to routers for other route types via subscript.
    public var projectedValue: RoutingContext {
        routingContext
    }

    // MARK: Initialization

    /// Creates a property wrapper that resolves a router for the given route type.
    public init(_ routeType: RouteType.Type = RouteType.self) {}

    // MARK: Methods

    /// Looks up a router for a different route type in the same environment.
    ///
    /// - Parameter for: The route type to search for.
    /// - Returns: The router for the given route type, or `nil` if no router is registered upstream.
    public func router<R: Route>(for: R.Type) -> (any Router<R>)? {
        routingContext[R.self]
    }

}

#endif
