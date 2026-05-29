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
open class NavigationCoordinator<RouteType: Route>: BaseCoordinator<RouteType, UINavigationController> {

    // MARK: Stored properties

    ///
    /// The animation delegate controlling the rootViewController's transition animations.
    /// It is installed as the navigation controller's `delegate` if no delegate was set earlier.
    ///
    /// - Note:
    ///     Use the ``delegate`` property to install your own delegate while keeping XCoordinator's
    ///     transition animations.
    ///
    public let animationDelegate = NavigationAnimationDelegate()
    // swiftlint:disable:previous weak_delegate

    // MARK: Computed properties

    ///
    /// A fallback delegate that receives navigation-controller events not consumed by XCoordinator,
    /// and is used to drive transition animations when no animation is specified by the route.
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
    /// - Parameters:
    ///   - rootViewController: The `UINavigationController` to host transitions. Defaults to a fresh instance.
    ///   - initialRoute: A route to trigger once the coordinator is shown. Defaults to `nil`.
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
    /// - Parameters:
    ///   - rootViewController: The `UINavigationController` to host transitions. Defaults to a fresh instance.
    ///   - root: The presentable to push as the initial view controller.
    ///
    public init(rootViewController: RootViewController = .init(), root: any Presentable) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialTransition: .push(root))
        animationDelegate.presentable = self
    }

    ///
    /// Creates a NavigationCoordinator and optionally performs an initial transition.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UINavigationController` to host transitions.
    ///   - initialTransition: A transition to perform once the coordinator is shown. Pass `nil` to skip.
    ///
    public override init(rootViewController: RootViewController, initialTransition: NavigationTransition?) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialTransition: initialTransition)
        animationDelegate.presentable = self
    }

    ///
    /// Creates a NavigationCoordinator and performs an initial transition described with the transition builder.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UINavigationController` to host transitions.
    ///   - initialTransition: A transition-builder closure describing the transition to perform.
    ///
    public override init(rootViewController: RootViewController,
                         @TransitionBuilder<UINavigationController> initialTransition: () -> NavigationTransition) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialTransition: initialTransition())
        animationDelegate.presentable = self
    }

}
