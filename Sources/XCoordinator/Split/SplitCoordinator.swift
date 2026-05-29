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
open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, UISplitViewController> {

    // MARK: Initialization

    ///
    /// Creates a SplitCoordinator and optionally triggers an initial route.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UISplitViewController` to host transitions. Defaults to a fresh instance.
    ///   - initialRoute: A route to trigger once the coordinator is shown.
    public override init(rootViewController: RootViewController = .init(), initialRoute: RouteType?) {
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }

    ///
    /// Creates a SplitCoordinator and optionally performs an initial transition.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UISplitViewController` to host transitions.
    ///   - initialTransition: A transition to perform once the coordinator is shown. Pass `nil` to skip.
    public override init(rootViewController: RootViewController, initialTransition: SplitTransition?) {
        super.init(rootViewController: rootViewController, initialTransition: initialTransition)
    }

    ///
    /// Creates a SplitCoordinator and performs an initial transition described with the transition builder.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UISplitViewController` to host transitions.
    ///   - initialTransition: A transition-builder closure describing the transition to perform.
    public override init(rootViewController: RootViewController,
                         @TransitionBuilder<UISplitViewController> initialTransition: () -> SplitTransition) {
        super.init(rootViewController: rootViewController, initialTransition: initialTransition())
    }

    ///
    /// Creates a SplitCoordinator and sets the specified presentables as the split controller's view controllers.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UISplitViewController` to host transitions. Defaults to a fresh instance.
    ///   - primary: The presentable shown in the primary column.
    ///   - secondary: The presentable shown in the secondary (detail) column. Optional, because a small-screen
    ///     device may not want to show a detail right away.
    ///   - supplementary: The presentable shown in the supplementary column (iOS 14+ triple-column splits). Optional.
    ///
    public init(rootViewController: RootViewController = .init(), primary: any Presentable, secondary: (any Presentable)?, supplementary: (any Presentable)? = nil) {
        super.init(rootViewController: rootViewController,
                   initialTransition: .set([primary, secondary, supplementary].compactMap { $0 }))
    }

}
