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
    private let _navigationController: () -> UINavigationController

    public init<U: Coordinator>(_ coordinator: U) where U.CoordinatorRoute == AnyRoute {
        _context = { coordinator.context }
        _navigationController = { coordinator.navigationController }
    }

    public var context: UIViewController! {
        return _context()
    }

    public var navigationController: UINavigationController {
        return _navigationController()
    }

}
