//
//  RoutingContext.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@MainActor
public struct RoutingContext: Equatable {
    
    // MARK: Static Functions
    
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
    
    public nonisolated init() {}
    
    public init(_ routers: [any Router] = []) {
        for router in routers {
            add(router)
        }
    }
    
    // MARK: Subscripts
    
    public subscript<R: Route>(_ routeType: R.Type) -> (any Router<R>)? {
        get { routers[ObjectIdentifier(routeType)]?.router(for: routeType) }
        set { routers[ObjectIdentifier(routeType)] = newValue }
    }
    
    // MARK: Methods
    
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

@available(iOS 13, tvOS 13, *)
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

@available(iOS 13, tvOS 13, *)
extension EnvironmentValues {
    internal var routingContext: RoutingContext {
        get { self[RoutingContext.EnvironmentKey.self] }
        set { self[RoutingContext.EnvironmentKey.self] = newValue }
    }
}

#endif
