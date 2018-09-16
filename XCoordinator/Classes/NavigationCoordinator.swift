//
//  NavigationCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class NavigationCoordinator<R: Route>: BaseCoordinator<R, NavigationTransition> {

    // MARK: - Stored properties

    internal var animationDelegate: NavigationControllerAnimationDelegate? = NavigationControllerAnimationDelegate()

    // MARK: - Computed properties

    public var delegate: UINavigationControllerDelegate? {
        return rootViewController.coordinatorDelegate
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
        let navigationController = super.generateRootViewController()
        navigationController.delegate = animationDelegate
        return navigationController
    }
}
