//
//  TabBarCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// Use a TabBarCoordinator to coordinate a flow where a `UITabbarController` serves as a rootViewController.
/// With a TabBarCoordinator, you get access to all tabbarController-related transitions.
///
open class TabBarCoordinator<RouteType: Route>: BaseCoordinator<RouteType, TabBarTransition> {

    // MARK: - Stored properties

    // swiftlint:disable:next weak_delegate
    private let animationDelegate = TabBarAnimationDelegate()

    // MARK: - Computed properties

    ///
    /// Use this delegate to get informed about tabbarController-related notifications and delegate methods
    /// specifying transition animations. The delegate is only referenced weakly.
    ///
    /// We encourage the setting of this delegate instead of overriding the `generateRootViewController`
    /// method, if possible, to allow for transition animations to be executed as specified in the
    /// `prepareTransition(for:)` method.
    ///
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

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs.
    ///
    /// - Parameter tabs:
    ///     The presentables to be used as tabs.
    ///
    public init(tabs: [Presentable]) {
        super.init(initialTransition: .set(tabs))
    }

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs and selects a specific presentable.
    ///
    /// - Parameter tabs:
    ///     The presentables to be used as tabs.
    ///
    /// - Parameter select:
    ///     The presentable to be selected before displaying. Make sure, this presentable is one of the
    ///     specified tabs in the other parameter.
    ///
    public init(tabs: [Presentable], select: Presentable) {
        super.init(initialTransition: .multiple(.set(tabs), .select(select)))
    }

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs and selects a presentable at a given index.
    ///
    /// - Parameter tabs:
    ///     The presentables to be used as tabs.
    ///
    /// - Parameter select:
    ///     The index of the presentable to be selected before displaying.
    ///
    public init(tabs: [Presentable], select: Int) {
        super.init(initialTransition: .multiple(.set(tabs), .select(index: select)))
    }

    // MARK: - Overrides

    ///
    /// Generates the rootViewController and sets its delegate.
    ///
    /// Use the `TabBarCoordinator.delegate` property to get informed about tabbarController-related
    /// notifications and specify animations. If you set the delegate of the rootViewController yourself,
    /// you will not get the transition animations specified in `prepareTransition` to work.
    ///
    open override func generateRootViewController() -> UITabBarController {
        let tabBarController = super.generateRootViewController()
        tabBarController.delegate = animationDelegate
        return tabBarController
    }
}
