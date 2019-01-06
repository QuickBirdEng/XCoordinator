//
//  Animation+TabBar.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class TabBarAnimationDelegate: NSObject {

    // MARK: - Stored properties

    internal var animation: Animation?
    internal weak var delegate: UITabBarControllerDelegate?
}

// MARK: - TabBarAnimationDelegate: UITabBarControllerDelegate

extension TabBarAnimationDelegate: UITabBarControllerDelegate {
    open func tabBarController(_ tabBarController: UITabBarController,
                               interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        return (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.tabBarController?(tabBarController, interactionControllerFor: animationController)
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation?.presentationAnimation
            ?? delegate?.tabBarController?(tabBarController, animationControllerForTransitionFrom: fromVC, to: toVC)
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                               didSelect viewController: UIViewController) {
        delegate?.tabBarController?(tabBarController, didSelect: viewController)
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                               shouldSelect viewController: UIViewController) -> Bool {
        return delegate?.tabBarController?(tabBarController, shouldSelect: viewController) ?? true
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                               willBeginCustomizing viewControllers: [UIViewController]) {
        delegate?.tabBarController?(tabBarController, willBeginCustomizing: viewControllers)
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                               didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, didEndCustomizing: viewControllers, changed: changed)
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                               willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, willEndCustomizing: viewControllers, changed: changed)
    }
}

extension UITabBarController {
    internal var animationDelegate: TabBarAnimationDelegate? {
        return delegate as? TabBarAnimationDelegate
    }
}
