//
//  RoutingController.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
extension Presentable {

    public static func hosted<Content: View>(
        by router: (any Router)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> Self where Self == RoutingController<Content> {
        RoutingController(rootView: content, router: router)
    }

    public static func hosted<Content: View>(
        _ content: Content,
        by router: (any Router)? = nil
    ) -> Self where Self == RoutingController<Content> {
        hosted(by: router) { content }
    }

}

@available(iOS 13.0, tvOS 13.0, *)
public class RoutingController<Content: View>: UIHostingController<RoutingContextView<Content>>, RoutingContextContaining {

    // MARK: Initialization

    public convenience init(rootView: Content, router: (any Router)? = nil) {
        self.init(rootView: { rootView }, router: router)
    }

    public init(@ViewBuilder rootView: @escaping () -> Content, router: (any Router)? = nil) {
        super.init(
            rootView: .init(
                content: rootView,
                context: .init(router)
            )
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Methods

    internal func replaceRoutingContext(with router: any Router, override: Bool) {
        rootView.replaceRoutingContext(with: router, override: override)
    }

}

#endif
