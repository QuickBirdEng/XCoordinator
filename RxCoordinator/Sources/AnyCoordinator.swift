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

    private let _context: () -> UIViewController
    private let _rootViewController: () -> UIViewController
    private let _transition: (AnyRoute,TransitionOptions) -> TransitionObservables

    public init<U: Coordinator>(_ coordinator: U) where U.CoordinatorRoute == AnyRoute {
        _context = { coordinator.context }
        _rootViewController = { coordinator.rootViewController }
        _transition = coordinator.transition
    }

    public var context: UIViewController! {
        return _context()
    }

    public var rootViewController: UIViewController {
        return _rootViewController()
    }

    public func transition(to route: AnyRoute, with options: TransitionOptions) -> TransitionObservables {
        return _transition(route, options)
    }

}
