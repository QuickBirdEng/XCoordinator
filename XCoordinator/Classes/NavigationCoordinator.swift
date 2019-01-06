//
//  NavigationCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class NavigationCoordinator<RouteType: Route>: BaseCoordinator<RouteType, NavigationTransition> {

    // MARK: - Stored properties

    // swiftlint:disable:next weak_delegate
    private let animationDelegate = NavigationAnimationDelegate()

    // MARK: - Computed properties

    public var delegate: UINavigationControllerDelegate? {
        get {
            return animationDelegate.delegate
        }
        set {
            animationDelegate.delegate = newValue
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
        let navigationController = super.generateRootViewController()
        navigationController.delegate = animationDelegate
        return navigationController
    }
}
