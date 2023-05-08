//
//  RoutingContextView.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public struct RoutingContextView<Content: View>: View, RoutingContextContaining {

    // MARK: Stored Properties

    private let content: () -> Content
    private let context: RoutingContext

    // MARK: Computed Properties

    public var body: some View {
        content()
            .environment(\.routingContext, context)
    }

    // MARK: Initialization

    internal init(
        @ViewBuilder content: @escaping () -> Content,
        context: RoutingContext
    ) {
        self.content = content
        self.context = context
    }

    // MARK: Methods

    internal func replaceRoutingContext(with router: any Router, override: Bool) {
        context.replaceRoutingContext(with: router, override: override)
    }

}

#endif
