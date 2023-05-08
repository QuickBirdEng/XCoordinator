//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import Foundation

@available(iOS 13.0, tvOS 13.0, *)
internal class RoutingContext {

    // MARK: Stored Properties

    private weak var context: (any Router)?

    // MARK: Initialization

    internal init(_ router: (any Router)? = nil) {
        self.context = router
    }

    // MARK: Methods

    internal func replaceContext(with router: any Router, override: Bool) {
        if context == nil || override {
            context = router
        }
    }

    internal func router<RouteType: Route>(for route: RouteType.Type) -> (any Router<RouteType>)? {
        context?.router(for: route)
    }

}

#endif
