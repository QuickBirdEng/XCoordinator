//
//  TabBarCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class TabBarCoordinator<RouteType: Route>: BaseCoordinator<RouteType, TabBarTransition> {

    // MARK: - Stored properties

    // swiftlint:disable:next weak_delegate
    private let animationDelegate = TabBarAnimationDelegate()

    // MARK: - Computed properties

    public var delegate: UITabBarControllerDelegate? {
        get {
            return animationDelegate.delegate
        }
        set {
            animationDelegate.delegate = newValue
        }
    }

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(tabs: [Presentable]) {
        super.init(initialTransition: .set(tabs))
    }

    public init(tabs: [Presentable], select: Presentable) {
        super.init(initialTransition: .multiple(.set(tabs), .select(select)))
    }

    public init(tabs: [Presentable], select: Int) {
        super.init(initialTransition: .multiple(.set(tabs), .select(index: select)))
    }

    // MARK: - Overrides

    open override func generateRootViewController() -> UITabBarController {
        let tabBarController = super.generateRootViewController()
        tabBarController.delegate = animationDelegate
        return tabBarController
    }
}
