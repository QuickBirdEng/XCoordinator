//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
extension Presentable {

    public static func hosted<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> Self where Self == RouterHostingController<Content> {
        RouterHostingController(rootView: .init(content: content, context: .init()))
    }

    public static func hosted<Content: View>(
        _ content: Content
    ) -> Self where Self == RouterHostingController<Content> {
        hosted { content }
    }

}

#endif
