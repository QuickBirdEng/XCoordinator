//
//  BasicCoordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

/// A BasicCoordinator with a `UINavigationController` as its rootViewController.
public typealias BasicNavigationCoordinator<R: Route> = BasicCoordinator<R, UINavigationController>

/// A BasicCoordinator with a `UIViewController` as its rootViewController.
public typealias BasicViewCoordinator<R: Route> = BasicCoordinator<R, UIViewController>

/// A BasicCoordinator with a `UITabBarController` as its rootViewController.
public typealias BasicTabBarCoordinator<R: Route> = BasicCoordinator<R, UITabBarController>

///
/// BasicCoordinator is a coordinator class that can be used without subclassing.
///
/// Although subclassing of coordinators is encouraged for more complex cases, a `BasicCoordinator` can easily
/// be created by only providing a `prepare` closure, an `initialRoute` and an `initialLoadingType`.
///
open class BasicCoordinator<RouteType: Route, RootViewController: UIViewController>: BaseCoordinator<RouteType, RootViewController> {

    // MARK: Nested types

    ///
    /// `InitialLoadingType` differentiates between different points in time when the initital route is to
    /// be triggered by the coordinator.
    ///
    public enum InitialLoadingType {

        /// The initial route is triggered before the coordinator is made visible (i.e. on initialization).
        case immediately

        /// The initial route is triggered after the coordinator is made visible.
        case presented
    }

    // MARK: Stored properties

    private let initialRoute: RouteType?
    private let initialLoadingType: InitialLoadingType
    private let prepareClosure: ((RouteType) -> Transition<RootViewController>)?

    // MARK: Initialization

    ///
    /// Creates a BasicCoordinator whose transitions are defined inline with the transition builder.
    ///
    /// The `prepare` closure is a `@TransitionBuilder`, so its body uses the same component / factory
    /// syntax as an overridden `prepareTransition(for:)`:
    ///
    /// ```swift
    /// BasicNavigationCoordinator<AppRoute>(rootViewController: .init(), initialRoute: .home) { route in
    ///     switch route {
    ///     case .home:   Show { HomeViewController() }
    ///     case .detail: Transition.push(DetailViewController())
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialRoute: If specified, this route is triggered depending on `initialLoadingType`.
    ///   - initialLoadingType: Determines when `initialRoute` is triggered. See ``InitialLoadingType``.
    ///   - prepare: A transition-builder closure returning the transition for each triggered route.
    ///
    public init(rootViewController: RootViewController,
                initialRoute: RouteType? = nil,
                initialLoadingType: InitialLoadingType = .presented,
                @TransitionBuilder<RootViewController> prepare: @escaping (RouteType) -> Transition<RootViewController>) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.prepareClosure = prepare

        if initialLoadingType == .immediately {
            super.init(rootViewController: rootViewController, initialRoute: initialRoute)
        } else {
            super.init(rootViewController: rootViewController, initialRoute: nil)
        }
    }

    ///
    /// Creates a BasicCoordinator that defines its transitions by overriding ``prepareTransition(for:)`` in a subclass.
    ///
    /// - Parameters:
    ///   - rootViewController: The view controller that hosts the coordinator's transitions.
    ///   - initialRoute: If specified, this route is triggered depending on `initialLoadingType`.
    ///   - initialLoadingType: Determines when `initialRoute` is triggered. See ``InitialLoadingType``.
    ///
    public init(rootViewController: RootViewController,
                initialRoute: RouteType? = nil,
                initialLoadingType: InitialLoadingType = .presented) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.prepareClosure = nil

        if initialLoadingType == .immediately {
            super.init(rootViewController: rootViewController, initialRoute: initialRoute)
        } else {
            super.init(rootViewController: rootViewController, initialRoute: nil)
        }
    }

    // MARK: Open methods

    ///
    /// This method is called whenever the BasicCoordinator is shown to the user.
    ///
    /// If `initialLoadingType` has been specified as `presented` and an initialRoute is present,
    /// the route is triggered here.
    ///
    /// - Parameter presentable:
    ///     The context in which this coordinator has been shown to the user.
    ///
    open override func presented(from presentable: (any Presentable)?) {
        super.presented(from: presentable)

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            trigger(initialRoute, with: TransitionOptions(animated: false), completion: nil)
        }
    }

    open override func prepareTransition(for route: RouteType) -> Transition<RootViewController> {
        if let prepareClosure = prepareClosure {
            return prepareClosure(route)
        } else {
            fatalError("Either pass a `prepare` closure to the initializer or override this method.")
        }
    }
}
