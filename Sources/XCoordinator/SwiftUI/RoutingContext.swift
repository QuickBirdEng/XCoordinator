//
//  RoutingContext.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
internal class RoutingContext: RoutingContextContaining {

    // MARK: Nested Types

    fileprivate enum Key: EnvironmentKey {
        static var defaultValue: RoutingContext { .init() }
    }

    // MARK: Stored Properties

    private weak var context: (any Router)?

    // MARK: Initialization

    internal init(_ context: (any Router)? = nil) {
        self.context = context
    }

    // MARK: Methods

    internal func replaceRoutingContext(with router: any Router, override: Bool) {
        guard context == nil || override else {
            return
        }
        context = router
    }

    internal func router<RouteType: Route>(for route: RouteType.Type) -> (any Router<RouteType>)? {
        context?.router(for: RouteType.self)
    }

}

@available(iOS 13.0, tvOS 13.0, *)
extension EnvironmentValues {

    internal var routingContext: RoutingContext {
        get { self[RoutingContext.Key.self] }
        set { self[RoutingContext.Key.self] = newValue }
    }

}

#endif
