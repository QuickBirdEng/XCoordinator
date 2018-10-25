//
//  AnyCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 25.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias AnyNavigationCoordinator<RouteType: Route> = AnyCoordinator<RouteType, Transition<UINavigationController>>
public typealias AnyTabBarCoordinator<RouteType: Route> = AnyCoordinator<RouteType, Transition<UITabBarController>>
public typealias AnyViewCoordinator<RouteType: Route> = AnyCoordinator<RouteType, Transition<UIViewController>>

public class AnyCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private var _prepareTransition: (RouteType) -> TransitionType
    private var _rootViewController: () -> TransitionType.RootViewController

    // MARK: - Initializer

    public init<C: Coordinator>(_ coordinator: C) where C.RouteType == RouteType, C.TransitionType == TransitionType {
        self._prepareTransition = coordinator.prepareTransition
        self._rootViewController = { coordinator.rootViewController }
    }

    // MARK: - Computed properties

    public var rootViewController: TransitionType.RootViewController {
        return _rootViewController()
    }

    // MARK: - Methods

    public func prepareTransition(for route: RouteType) -> TransitionType {
        return _prepareTransition(route)
    }
}
