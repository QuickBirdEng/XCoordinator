//
//  RedirectionCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// RedirectionCoordinators can be used to break up huge routes into smaller ones, like dividing a flow into subflows.
/// In contrast to the RedirectionRouter, the RedirectionCoordinator does not need to know about the coordinator's RouteType
/// but instead keeps a dependency on its TransitionType.
///
/// Create a RedirectionCoordinator from a superCoordinator by providing a reference to the superCoordinator.
/// Triggered routes of the RedirectionCoordinator will be mapped to the superCoordinator's TransitionType
/// and performed using the superCoordinator's rootViewController.
/// Please provide either a `prepareTransition` closure in the initializer or override the `prepareTransition(for:)` method.
///
/// A RedirectionCoordinator has a viewController, which is used in transitions, e.g. when presenting, pushing or otherwise displaying it.
///
open class RedirectionCoordinator<ViewController: UIViewController, RouteType: Route, TransitionType: TransitionProtocol>: BaseCoordinator<RouteType, TransitionType> {

    // MARK: - Computed properties
    
    private var _viewController: UIViewController!

    open override var viewController: UIViewController! {
        _viewController
    }

    // MARK: - Initialization

    ///
    /// Creates a RedirectionCoordinator with a viewController, a superTransitionPerfomer and an optional `prepareTransition` closure.
    ///
    /// - Note:
    ///     Make sure to either override `prepareTransition(for:)` or to specify a closure as the `prepareTransition` parameter.
    ///     Overriding `prepareTransition(for:)` results in the closure being ignored.
    ///
    /// - Parameters:
    ///     - viewController:
    ///         The viewController used in transitions, e.g. when presenting, pushing or otherwise displaying a RedirectionCoordinator.
    ///     - superTransitionPerformer:
    ///         The superCoordinator's AnyTransitionPerformer object all transitions are redirected to.
    ///     - prepareTransition:
    ///         A closure preparing transitions for triggered routes.
    ///
    public init(rootViewController: RootViewController,
                viewController: UIViewController) {
        _viewController = viewController
        super.init(rootViewController: rootViewController,
                   initialRoute: nil)
    }
}
