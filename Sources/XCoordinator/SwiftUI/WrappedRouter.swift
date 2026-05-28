//
//  WrappedRouter.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 20.05.25.
//

#if canImport(SwiftUI)

import SwiftUI

///
/// A SwiftUI view that embeds a UIKit-backed coordinator or router and exposes it via the routing environment.
///
/// Use `WrappedRouter` when you want to drive a coordinator-based flow from inside a SwiftUI hierarchy
/// — for example, hosting an entire `NavigationCoordinator` inside a SwiftUI scene. The `create` closure
/// is called once per view identity to instantiate the router; the resulting instance is retained for
/// the lifetime of the view, and is registered in the surrounding `RoutingContext` so descendant SwiftUI
/// views can resolve it via `@Routing`.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         WrappedRouter { UsersCoordinator() }
///     }
/// }
/// ```
///
public struct WrappedRouter<RouterType: Router>: View {

    // MARK: Stored Properties

    @State private var routingContext = RoutingContext()
    private let create: () -> RouterType
    private let update: (UIViewController, any RepresentableContext<RouterType>) -> Void

    // MARK: Computed Properties

    public var body: some View {
        Representable {
            let router = create()
            routingContext.add(router)
            return router
        } update: {
            update($0, $1)
        }
        .routingContext(routingContext)
    }

    // MARK: Initialization

    ///
    /// Creates a wrapped router view.
    ///
    /// - Parameters:
    ///   - create: A closure that builds the router. Called once per view identity, on first appearance.
    ///     The returned router is retained for the lifetime of the view and registered in the
    ///     routing context propagated to descendants.
    ///   - update: A closure invoked on each SwiftUI update of the underlying representable. Use it
    ///     to forward SwiftUI state into the hosted UIKit view controller. Defaults to a no-op.
    ///
    public init(
        create: @escaping () -> RouterType,
        update: @escaping (UIViewController, any RepresentableContext<RouterType>) -> Void = { _, _ in }
    ) {
        self.create = create
        self.update = update
    }

}

#endif
