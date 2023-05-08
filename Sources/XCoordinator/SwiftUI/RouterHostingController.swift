//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public class RouterHostingController<Content: View>: UIHostingController<RouterContextView<Content>>, RouterContextReplacable {

    // MARK: Initialization

    public init(rootView: Content) {
        super.init(rootView: .init(content: { rootView }, context: .init()))
    }

    public init(@ViewBuilder rootView: @escaping () -> Content) {
        super.init(rootView: .init(content: rootView, context: .init()))
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Methods

    public func replaceContext(with router: any Router) {
        rootView.replaceContext(with: router)
    }

}

#endif
