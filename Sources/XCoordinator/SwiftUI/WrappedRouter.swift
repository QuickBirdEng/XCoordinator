//
//  WrappedRouter.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 20.05.25.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, tvOS 13, *)
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
    
    public init(
        create: @escaping () -> RouterType,
        update: @escaping (UIViewController, any RepresentableContext<RouterType>) -> Void = { _, _ in }
    ) {
        self.create = create
        self.update = update
    }
    
}

#endif
