//
//  AnyCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 25.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

/// A type-erased Coordinator (`AnyCoordinator`) with a `UINavigationController` as rootViewController.
public typealias AnyNavigationCoordinator<RouteType: Route> = AnyCoordinator<RouteType, NavigationTransition>

/// A type-erased Coordinator (`AnyCoordinator`) with a `UITabBarController` as rootViewController.
public typealias AnyTabBarCoordinator<RouteType: Route> = AnyCoordinator<RouteType, TabBarTransition>

/// A type-erased Coordinator (`AnyCoordinator`) with a `UIViewController` as rootViewController.
public typealias AnyViewCoordinator<RouteType: Route> = AnyCoordinator<RouteType, ViewTransition>

///
/// `AnyCoordinator` is a type-erased `Coordinator` (`RouteType` & `TransitionType`) and
/// can be used as an abstraction from a specific coordinator class while still specifying
/// TransitionType and RouteType.
///
/// - Note:
///     If you do not want/need to specify TransitionType, you might want to look into the
///     different router abstractions `StrongRouter`, `UnownedRouter` and `WeakRouter`.
///     See `AnyTransitionPerformer` to further abstract from RouteType.
///
public class AnyCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: Stored properties

    private let _prepareTransition: (RouteType) -> TransitionType
    private let _viewController: () -> UIViewController?
    private let _rootViewController: () -> TransitionType.RootViewController
    private let _presented: (Presentable?) -> Void
    private let _setRoot: (UIWindow) -> Void
    private let _addChild: (Presentable) -> Void
    private let _removeChild: (Presentable) -> Void
    private let _removeChildrenIfNeeded: () -> Void
    private let _registerParent: (Presentable & AnyObject) -> Void
    
    // MARK: Initialization

    ///
    /// Creates a type-erased Coordinator for a specific coordinator.
    ///
    /// A strong reference to the source coordinator is kept.
    ///
    /// - Parameter coordinator:
    ///     The source coordinator.
    ///
    public init<C: Coordinator>(_ coordinator: C) where C.RouteType == RouteType, C.TransitionType == TransitionType {
        self._prepareTransition = coordinator.prepareTransition
        self._viewController = { coordinator.viewController }
        self._rootViewController = { coordinator.rootViewController }
        self._presented = coordinator.presented
        self._setRoot = coordinator.setRoot
        self._addChild = coordinator.addChild
        self._removeChild = coordinator.removeChild
        self._removeChildrenIfNeeded = coordinator.removeChildrenIfNeeded
        self._registerParent = coordinator.registerParent
    }

    // MARK: Computed properties

    public var rootViewController: TransitionType.RootViewController {
        _rootViewController()
    }

    public var viewController: UIViewController! {
        _viewController()
    }

    // MARK: Methods

    ///
    /// Prepare and return transitions for a given route.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
    /// - Returns:
    ///     The prepared transition.
    ///
    public func prepareTransition(for route: RouteType) -> TransitionType {
        _prepareTransition(route)
    }

    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }
    
    public func registerParent(_ presentable: Presentable & AnyObject) {
        _registerParent(presentable)
    }

    public func setRoot(for window: UIWindow) {
        _setRoot(window)
    }
    
    public func addChild(_ presentable: Presentable) {
        _addChild(presentable)
    }
    
    public func removeChild(_ presentable: Presentable) {
        _removeChild(presentable)
    }
    
    public func removeChildrenIfNeeded() {
        _removeChildrenIfNeeded()
    }

}
