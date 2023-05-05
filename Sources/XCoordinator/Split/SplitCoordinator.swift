//
//  SplitCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// SplitCoordinator can be used as a basis for a coordinator with a rootViewController of type
/// `UISplitViewController`.
///
/// You can use all `SplitTransitions` and get an initializer to set a master and
/// (optional) detail presentable.
///
open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, SplitTransition> {

    // MARK: Initialization

    public override init(rootViewController: RootViewController = .init(), initialRoute: RouteType?) {
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }

    ///
    /// Creates a SplitCoordinator and sets the specified presentables as the rootViewController's
    /// viewControllers.
    ///
    /// - Parameters:
    ///     - primary:
    ///         The presentable to be shown as primary in the `UISplitViewController`.
    ///     - secondary:
    ///         The presentable to be shown as secondary in the `UISplitViewController`. This is optional due to
    ///         the fact that it might not be useful to have a detail page right away on a small-screen device.
    ///
    public init(rootViewController: RootViewController = .init(), primary: any Presentable, secondary: (any Presentable)?, supplementary: (any Presentable)? = nil) {
        super.init(rootViewController: rootViewController,
                   initialTransition: .set([primary, secondary, supplementary].compactMap { $0 }))
    }

}
