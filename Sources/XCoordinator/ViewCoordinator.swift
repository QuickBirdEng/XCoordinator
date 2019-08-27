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

    // MARK: - Initialization

    public override init(rootViewController: RootViewController, initialRoute: RouteType?) {
        super.init(rootViewController: rootViewController,
                   initialRoute: initialRoute)
    }

    ///
    /// Creates a ViewCoordinator and embeds the root presentable into the rootViewController.
    ///
    /// - Parameter root:
    ///     The presentable to be embedded.
    ///
    public init(rootViewController: RootViewController, root: Presentable) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        performTransition(.embed(root, in: rootViewController), with: TransitionOptions(animated: false))
    }
}
