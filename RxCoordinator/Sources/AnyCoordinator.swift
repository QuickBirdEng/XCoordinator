//
//  AnyCoordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import UIKit

public final class AnyCoordinator<AnyRoute: Route>: Coordinator {
    public typealias CoordinatorRoute = AnyRoute

    private let _context: () -> UIViewController?
    private let _rootViewController: () -> UIViewController
    private let _transition: (AnyRoute, TransitionOptions, PresentationHandler?) -> Void
    private let _prepareTransition: (CoordinatorRoute) -> AnyRoute.TransitionType
    private let _presented: (Presentable?) -> Void

    public init<U: Coordinator>(_ coordinator: U) where U.CoordinatorRoute == AnyRoute {
        _context = { coordinator.context }
        _rootViewController = { coordinator.rootViewController }
        _transition = coordinator.trigger
        _prepareTransition = coordinator.prepareTransition
        _presented = coordinator.presented
    }

    public var context: UIViewController? {
        return _context()
    }

    public var rootViewController: UIViewController {
        return _rootViewController()
    }

    public func trigger(_ route: AnyRoute, with options: TransitionOptions, completion: PresentationHandler?) {
        return _transition(route, options, completion)
    }

    public func prepareTransition(for route: AnyRoute) -> CoordinatorRoute.TransitionType {
        return _prepareTransition(route)
    }

    public func presented(from presentable: Presentable?) {
        return _presented(presentable)
    }

}
