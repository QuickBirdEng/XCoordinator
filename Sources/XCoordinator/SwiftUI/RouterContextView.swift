//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public struct RouterContextView<Content: View>: View, RouterContextReplacable {

    // MARK: Stored Properties

    private let content: () -> Content
    private let context: RouterContext

    // MARK: Computed Properties

    public var body: some View {
        content()
            .environment(\.router, context)
    }

    // MARK: Initialization

    internal init(
        @ViewBuilder content: @escaping () -> Content,
        context: RouterContext
    ) {
        self.content = content
        self.context = context
    }

    // MARK: Methods

    public func replaceContext(with router: any Router) {
        context.replaceContext(with: router)
    }

}

#endif
