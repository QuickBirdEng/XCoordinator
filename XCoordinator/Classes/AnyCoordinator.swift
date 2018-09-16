//
//  AnyCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public final class AnyCoordinator<RouteType: Route>: RouteTrigger, Presentable {

    // MARK: - Stored properties

    private let _trigger: (RouteType, TransitionOptions, PresentationHandler?) -> Void
    private let _presented: (Presentable?) -> Void
    private let _viewController: () -> UIViewController
    private let _setRoot: (UIWindow) -> Void

    // MARK: - Init

    public init<C: Coordinator>(_ coordinator: C) where C.RouteType == RouteType {
        _trigger = coordinator.trigger
        _presented = coordinator.presented
        _viewController = { coordinator.viewController }
        _setRoot = coordinator.setRoot
    }

    // MARK: - Public methods

    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        _trigger(route, options, completion)
    }

    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }

    public var viewController: UIViewController! {
        return _viewController()
    }

    public func setRoot(for window: UIWindow) {
        _setRoot(window)
    }
    
}
