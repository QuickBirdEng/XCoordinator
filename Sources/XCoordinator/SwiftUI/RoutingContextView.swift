//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public struct RoutingContextView<Content: View>: View {

    // MARK: Stored Properties

    private let content: () -> Content
    internal let context: RoutingContext

    // MARK: Computed Properties

    public var body: some View {
        content()
            .environment(\.router, context)
    }

    // MARK: Initialization

    internal init(
        @ViewBuilder content: @escaping () -> Content,
        context: RoutingContext
    ) {
        self.content = content
        self.context = context
    }

}

#endif
