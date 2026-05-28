//
//  RoutingContextProvider.swift
//  XCoordinator
//
//  Created by Paul Kraft on 09.05.2025.
//

#if canImport(SwiftUI)

///
/// A type that exposes a writable ``RoutingContext`` for downstream propagation through the SwiftUI environment.
///
/// Conforming types (such as ``RoutingController``) participate in the routing-context machinery used by
/// `Coordinator.performTransition`: when a transition produces presentables that conform to this protocol,
/// the coordinator registers itself in their `routingContext` so that descendant SwiftUI views can resolve
/// the coordinator via `@Routing`.
///
public protocol RoutingContextProvider {

    /// The routing context provided to the SwiftUI environment.
    var routingContext: RoutingContext { get nonmutating set }
}

#endif
