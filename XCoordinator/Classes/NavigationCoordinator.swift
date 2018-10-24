//
//  NavigationCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class NavigationCoordinator<R: Route>: BaseCoordinator<R, NavigationTransition> {

    // MARK: - Stored properties

    internal var animationDelegate: NavigationAnimationDelegate? = NavigationAnimationDelegate()

    // MARK: - Computed properties

    public var delegate: UINavigationControllerDelegate? {
        get {
            return rootViewController.coordinatorDelegate
        }
        set {
            rootViewController.coordinatorDelegate = newValue
        }
    }

    // MARK: - Init
    public override init(initialRoute: RouteType? = nil) {
        super.init(initialRoute: initialRoute)
    }

    public init(root: Presentable) {
        super.init(initialTransition: .push(root))
    }

    // MARK: - Overrides
    open override func generateRootViewController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.delegate = animationDelegate
        return navigationController
    }
}
