//
//  ViewCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// ViewTransition offers transitions common to any `UIViewController` rootViewController.
///
public typealias ViewTransition = Transition<UIViewController>

///
/// ViewCoordinator is a base class for your own custom coordinator with a `UIViewController`
/// rootViewController.
///
open class ViewCoordinator<RouteType: Route>: BaseCoordinator<RouteType, ViewTransition> {

    // MARK: - Initialization

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    ///
    /// Creates a ViewCoordinator and embeds the root-presentable into the rootViewController.
    ///
    /// - Parameter root:
    ///     The presentable to be embedded.
    ///
    public init(root: Presentable) {
        super.init(initialRoute: nil)
        embed(root.viewController, in: rootViewController, with: TransitionOptions(animated: false), completion: nil)
    }
}
