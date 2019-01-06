//
//  AnyCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 25.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

/// An `AnyCoordinator` with a `UINavigationController` as rootViewController.
public typealias AnyNavigationCoordinator<RouteType: Route> = AnyCoordinator<RouteType, NavigationTransition>

/// An `AnyCoordinator` with a `UITabBarController` as rootViewController.
public typealias AnyTabBarCoordinator<RouteType: Route> = AnyCoordinator<RouteType, TabBarTransition>

/// An `AnyCoordinator` with a `UIViewController` as rootViewController.
public typealias AnyViewCoordinator<RouteType: Route> = AnyCoordinator<RouteType, ViewTransition>

///
/// AnyCoordinator can be used as an abstraction from a specific coordinator class while still specifying
/// TransitionType and RouteType.
///
/// If you do not want/need to specify TransitionType, you might want to look into the `AnyRouter` class.
/// See `AnyTransitionPerformer` to further abstract away from RouteType.
///
public class AnyCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let _prepareTransition: (RouteType) -> TransitionType
    private let _rootViewController: () -> TransitionType.RootViewController
    private let _presented: (Presentable?) -> Void
    private let _setRoot: (UIWindow) -> Void

    // MARK: - Initialization

    ///
    /// Creates an AnyCoordinator of a specific coordinator.
    ///
    /// The specified coordinator is held strongly.
    ///
    /// - Parameter coordinator:
    ///     The coordinator to be masked.
    ///
    public init<C: Coordinator>(_ coordinator: C) where C.RouteType == RouteType, C.TransitionType == TransitionType {
        self._prepareTransition = coordinator.prepareTransition
        self._rootViewController = { coordinator.rootViewController }
        self._presented = coordinator.presented
        self._setRoot = coordinator.setRoot
    }

    // MARK: - Computed properties

    public var rootViewController: TransitionType.RootViewController {
        return _rootViewController()
    }

    // MARK: - Methods

    ///
    /// Prepare transitions for specific routes and return the transitions.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
    /// - Returns:
    ///     The prepared transition.
    ///
    public func prepareTransition(for route: RouteType) -> TransitionType {
        return _prepareTransition(route)
    }

    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }

    public func setRoot(for window: UIWindow) {
        _setRoot(window)
    }
}
