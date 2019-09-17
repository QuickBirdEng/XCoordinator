//
//  ViewCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// ViewTransition offers transitions common to any `UIViewController` rootViewController.
///
public typealias ViewTransition = Transition<UIViewController>

///
/// ViewCoordinator is a base class for custom coordinators with a `UIViewController` rootViewController.
///
open class ViewCoordinator<RouteType: Route>: BaseCoordinator<RouteType, ViewTransition> {

    // MARK: Initialization

    public override init(rootViewController: RootViewController, initialRoute: RouteType? = nil) {
        super.init(rootViewController: rootViewController,
                   initialRoute: initialRoute)
    }

}
