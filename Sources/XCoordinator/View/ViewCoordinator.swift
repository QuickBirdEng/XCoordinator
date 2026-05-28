//
//  ViewCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

#endif

import UIKit

///
/// ViewTransition offers transitions common to any `UIViewController` rootViewController.
///
public typealias ViewTransition = Transition<UIViewController>

///
/// ViewCoordinator is a base class for custom coordinators with a `UIViewController` rootViewController.
///
open class ViewCoordinator<RouteType: Route>: BaseCoordinator<RouteType, ViewTransition> {

    // MARK: Initialization
    
    ///
    /// Creates a view coordinator with the given root view controller and an optional initial transition.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialTransition: A transition to perform once the coordinator is shown. Pass `nil` to skip.
    public override init(rootViewController: RootViewController, initialTransition: TransitionType?) {
        super.init(rootViewController: rootViewController,
                   initialTransition: initialTransition)
    }

    ///
    /// Creates a view coordinator with the given root view controller and an optional initial route.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialRoute: A route triggered once the coordinator is shown. Defaults to `nil`.
    public override init(rootViewController: RootViewController, initialRoute: RouteType? = nil) {
        super.init(rootViewController: rootViewController,
                   initialRoute: initialRoute)
    }

    #if canImport(SwiftUI)

    ///
    /// Creates a view coordinator whose root is a SwiftUI view, optionally triggering an initial route.
    ///
    /// The view is hosted inside a ``RoutingController`` so it participates in the routing context.
    ///
    /// - Parameters:
    ///   - initialRoute: A route triggered once the coordinator is shown.
    ///   - body: A view-builder producing the SwiftUI content.
    public init<Content: View>(
        initialRoute: RouteType? = nil,
        @ViewBuilder body: () -> Content
    ) {
        super.init(
            rootViewController: RoutingController(rootView: body()),
            initialRoute: initialRoute
        )
    }

    ///
    /// Creates a view coordinator whose root is a SwiftUI view, optionally performing an initial transition.
    ///
    /// - Parameters:
    ///   - initialTransition: A transition to perform once the coordinator is shown.
    ///   - body: A view-builder producing the SwiftUI content.
    public init<Content: View>(
        initialTransition: TransitionType?,
        @ViewBuilder body: () -> Content
    ) {
        super.init(
            rootViewController: RoutingController(rootView: body()),
            initialTransition: initialTransition
        )
    }

    #endif

}
