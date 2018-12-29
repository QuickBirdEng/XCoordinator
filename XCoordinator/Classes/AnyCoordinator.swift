//
//  AnyCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 25.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias AnyNavigationCoordinator<RouteType: Route> = AnyCoordinator<RouteType, NavigationTransition>
public typealias AnyTabBarCoordinator<RouteType: Route> = AnyCoordinator<RouteType, TabBarTransition>
public typealias AnyViewCoordinator<RouteType: Route> = AnyCoordinator<RouteType, ViewTransition>

public class AnyCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let _prepareTransition: (RouteType) -> TransitionType
    private let _rootViewController: () -> TransitionType.RootViewController
    private let _presented: (Presentable?) -> Void
    private let _setRoot: (UIWindow) -> Void

    // MARK: - Initializer

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
