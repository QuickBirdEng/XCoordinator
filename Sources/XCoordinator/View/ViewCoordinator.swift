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
    
    public override init(rootViewController: RootViewController, initialTransition: TransitionType?) {
        super.init(rootViewController: rootViewController,
                   initialTransition: initialTransition)
    }

    public override init(rootViewController: RootViewController, initialRoute: RouteType? = nil) {
        super.init(rootViewController: rootViewController,
                   initialRoute: initialRoute)
    }
    
    #if canImport(SwiftUI)
    
    @available(iOS 13, tvOS 13, *)
    public init<Content: View>(
        initialRoute: RouteType? = nil,
        @ViewBuilder body: () -> Content
    ) {
        super.init(
            rootViewController: RoutingController(rootView: body()),
            initialRoute: initialRoute
        )
    }
    
    @available(iOS 13, tvOS 13, *)
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
