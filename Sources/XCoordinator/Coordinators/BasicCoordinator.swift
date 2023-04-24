//
//  BasicCoordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

/// A BasicCoordinator with a `UINavigationController` as its rootViewController.
public typealias BasicNavigationCoordinator<R: Route> = BasicCoordinator<R, NavigationTransition>

/// A BasicCoordinator with a `UIViewController` as its rootViewController.
public typealias BasicViewCoordinator<R: Route> = BasicCoordinator<R, ViewTransition>

/// A BasicCoordinator with a `UITabBarController` as its rootViewController.
public typealias BasicTabBarCoordinator<R: Route> = BasicCoordinator<R, TabBarTransition>

///
/// BasicCoordinator is a coordinator class that can be used without subclassing.
///
/// Although subclassing of coordinators is encouraged for more complex cases, a `BasicCoordinator` can easily
/// be created by only providing a `prepareTransition` closure, an `initialRoute` and an `initialLoadingType`.
///
open class BasicCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: BaseCoordinator<RouteType, TransitionType> {

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
    private let prepareTransition: ((RouteType) -> TransitionType)?

    // MARK: Initialization

    ///
    /// Creates a BasicCoordinator.
    ///
    /// - Parameters:
    ///     - initialRoute:
    ///         If a route is specified, it is triggered depending on the initialLoadingType.
    ///     - initialLoadingType:
    ///         The initialLoadingType specifies when the initialRoute is triggered.
    ///     - prepareTransition:
    ///         A closure to define transitions based on triggered routes.
    ///         Make sure to override `prepareTransition` by subclassing, if you specify `nil` here.
    ///
    /// - Seealso:
    ///     See `InitialLoadingType` for more information.
    ///
    public init(rootViewController: RootViewController,
                initialRoute: RouteType? = nil,
                initialLoadingType: InitialLoadingType = .presented,
                prepareTransition: ((RouteType) -> TransitionType)?) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.prepareTransition = prepareTransition

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
    open override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            trigger(initialRoute, with: TransitionOptions(animated: false), completion: nil)
        }
    }

    open override func prepareTransition(for route: RouteType) -> TransitionType {
        if let prepareTransition = prepareTransition {
            return prepareTransition(route)
        } else {
            fatalError("Either pass a \(#function) closure to the initializer or override this method.")
        }
    }
}
