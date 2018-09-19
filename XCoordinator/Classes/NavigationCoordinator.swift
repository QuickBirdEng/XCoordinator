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
        return AnimationNavigationController(animationDelegate: animationDelegate)
    }
}

class AnimationNavigationController: UINavigationController {
    var _delegate: NavigationAnimationDelegate?

    convenience init(animationDelegate: NavigationAnimationDelegate?) {
        self.init()
        self._delegate = animationDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = _delegate
    }
}
