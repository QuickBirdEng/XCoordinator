//
//  NavigationCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// NavigationCoordinator acts as a base class for your own custom coordinator with a `UINavigationController` rootViewController.
///
/// NavigationCoordinator especially ensures that transition animations are called,
/// which would not be the case when creating a `BaseCoordinator<RouteType, NavigationTransition>`.
///
open class NavigationCoordinator<RouteType: Route>: BaseCoordinator<RouteType, NavigationTransition> {

    // MARK: - Stored properties

    // swiftlint:disable:next weak_delegate
    private let animationDelegate = NavigationAnimationDelegate()

    // MARK: - Computed properties

    ///
    /// This represents a fallback-delegate to be notified about navigation controller events.
    /// It is further used for animation methods when no animation has been specified in the transition.
    ///
    public var delegate: UINavigationControllerDelegate? {
        get {
            return animationDelegate.delegate
        }
        set {
            animationDelegate.delegate = newValue
        }
    }

    // MARK: - Initialization

    ///
    /// Creates a NavigationCoordinator and optionally triggers an initial route.
    ///
    /// - Parameter initialRoute:
    ///     The route to be triggered.
    ///
    public override init(initialRoute: RouteType? = nil) {
        super.init(initialRoute: initialRoute)
    }

    ///
    /// Creates a NavigationCoordinator and pushes a presentable onto the navigation stack right away.
    ///
    /// - Parameter root:
    ///     The presentable to be pushed.
    ///
    public init(root: Presentable) {
        super.init(initialTransition: .push(root))
    }

    // MARK: - Overrides

    open override func generateRootViewController() -> UINavigationController {
        let navigationController = super.generateRootViewController()
        navigationController.delegate = animationDelegate
        return navigationController
    }
}
