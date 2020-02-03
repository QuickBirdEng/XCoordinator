//
//  NavigationCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// NavigationCoordinator acts as a base class for custom coordinators with a `UINavigationController`
/// as rootViewController.
///
/// NavigationCoordinator especially ensures that transition animations are called,
/// which would not be the case when creating a `BaseCoordinator<RouteType, NavigationTransition>`.
///
open class NavigationCoordinator<RouteType: Route>: BaseCoordinator<RouteType, NavigationTransition> {

    // MARK: Stored properties

    ///
    /// The animation delegate controlling the rootViewController's transition animations.
    /// This animation delegate is set to be the rootViewController's rootViewController, if you did not set one earlier.
    ///
    /// - Note:
    ///     Use the `delegate` property to set a custom delegate and use transition animations provided by XCoordinator.
    ///
    public let animationDelegate = NavigationAnimationDelegate()
    // swiftlint:disable:previous weak_delegate

    // MARK: Computed properties

    ///
    /// This represents a fallback-delegate to be notified about navigation controller events.
    /// It is further used to call animation methods when no animation has been specified in the transition.
    ///
    public var delegate: UINavigationControllerDelegate? {
        get {
            animationDelegate.delegate
        }
        set {
            animationDelegate.delegate = newValue
        }
    }

    // MARK: Initialization

    ///
    /// Creates a NavigationCoordinator and optionally triggers an initial route.
    ///
    /// - Parameter initialRoute:
    ///     The route to be triggered.
    ///
    public override init(rootViewController: RootViewController = .init(), initialRoute: RouteType? = nil) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
        animationDelegate.presentable = self
    }

    ///
    /// Creates a NavigationCoordinator and pushes a presentable onto the navigation stack right away.
    ///
    /// - Parameter root:
    ///     The presentable to be pushed.
    ///
    public init(rootViewController: RootViewController = .init(), root: Presentable) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialTransition: .push(root))
        animationDelegate.presentable = self
    }

}
