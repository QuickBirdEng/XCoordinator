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

    // MARK: Methods

    public func replaceContext(with router: any Router) {
        rootView.replaceContext(with: router)
    }

}

#endif
