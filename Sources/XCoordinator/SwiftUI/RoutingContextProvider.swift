//
//  RoutingContextProvider.swift
//  XCoordinator
//
//  Created by Paul Kraft on 09.05.2025.
//

#if canImport(SwiftUI)

public protocol RoutingContextProvider {
    var routingContext: RoutingContext { get nonmutating set }
}

#endif
