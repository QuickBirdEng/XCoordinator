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
open class ViewCoordinator<RouteType: Route>: BaseCoordinator<RouteType, UIViewController> {

    // MARK: Initialization
    
    ///
    /// Creates a view coordinator with the given root view controller and an optional initial transition.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialTransition: A transition to perform once the coordinator is shown. Pass `nil` to skip.
    public override init(rootViewController: RootViewController, initialTransition: ViewTransition?) {
        super.init(rootViewController: rootViewController,
                   initialTransition: initialTransition)
    }

    ///
    /// Creates a view coordinator and performs an initial transition described with the transition builder.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialTransition: A transition-builder closure describing the transition to perform.
    public override init(rootViewController: RootViewController,
                         @TransitionBuilder<UIViewController> initialTransition: () -> ViewTransition) {
        super.init(rootViewController: rootViewController,
                   initialTransition: initialTransition())
    }

    ///
    /// Creates a view coordinator with the given root view controller and an optional initial route.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialRoute: A route triggered once the coordinator is shown. Defaults to `nil`.
    public override init(rootViewController: RootViewController, initialRoute: RouteType? = nil) {
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
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
        let controller = RoutingController(rootView: body())
        super.init(
            rootViewController: controller,
            initialRoute: initialRoute
        )
        controller.routingContext.add(self)
    }

    ///
    /// Creates a view coordinator whose root is a SwiftUI view, optionally performing an initial transition.
    ///
    /// - Parameters:
    ///   - initialTransition: A transition to perform once the coordinator is shown.
    ///   - body: A view-builder producing the SwiftUI content.
    public init<Content: View>(
        initialTransition: ViewTransition?,
        @ViewBuilder body: () -> Content
    ) {
        let controller = RoutingController(rootView: body())
        super.init(
            rootViewController: controller,
            initialTransition: initialTransition
        )
        controller.routingContext.add(self)
    }

    ///
    /// Creates a view coordinator whose root is a SwiftUI view, performing an initial transition
    /// described with the transition builder.
    ///
    /// - Parameters:
    ///   - initialTransition: A transition-builder closure describing the transition to perform.
    ///   - body: A view-builder producing the SwiftUI content.
    public init<Content: View>(
        @TransitionBuilder<UIViewController> initialTransition: () -> ViewTransition,
        @ViewBuilder body: () -> Content
    ) {
        let controller = RoutingController(rootView: body())
        super.init(
            rootViewController: controller,
            initialTransition: initialTransition()
        )
        controller.routingContext.add(self)
    }

    #endif

}
