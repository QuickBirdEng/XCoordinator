//
//  RoutingController.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, tvOS 13, *)
public class RoutingController<Content: View>: UIHostingController<RoutingController<Content>.InjectorView>, RoutingContextProvider {
    
    // MARK: Nested Types
    
    public struct InjectorView: View {
        
        // MARK: Stored Properties
        
        private let routingContext: RoutingContext
        private let content: Content
        private let onUpdate: (RoutingContext) -> Void
        
        // MARK: Computed Properties
        
        public var body: some View {
            content
                .environment(\.routingContext, routingContext)
                .onRoutingContextChanged(perform: onUpdate)
        }
        
        // MARK: Initialization
        
        fileprivate init(
            context: RoutingContext,
            content: Content,
            onUpdate: @escaping (RoutingContext) -> Void
        ) {
            self.routingContext = context
            self.content = content
            self.onUpdate = onUpdate
        }

    }

    // MARK: Properties
    
    public var routingContext: RoutingContext
    private var routingContent = RoutingContext()
    
    // MARK: Initialization

    public init(
        context: RoutingContext = .init(),
        rootView: Content
    ) {
        self.routingContext = context
        var onUpdate: ((RoutingContext) -> Void)?
        super.init(
            rootView: InjectorView(
                context: context,
                content: rootView
            ) { updatedContext in
                onUpdate?(updatedContext)
            }
        )
        onUpdate = { [weak self] updatedContext in
            self?.routingContext = updatedContext
        }
    }

    public convenience init(
        context: RoutingContext = .init(),
        @ViewBuilder rootView: () -> Content
    ) {
        self.init(context: context, rootView: rootView())
    }

    public required init?(coder aDecoder: NSCoder) {
        self.routingContext = .init()
        super.init(coder: aDecoder)
    }

}

#endif
