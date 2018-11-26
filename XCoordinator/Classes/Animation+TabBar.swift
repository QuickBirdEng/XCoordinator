//
//  Animation+TabBar.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

class TabBarAnimationDelegate: NSObject, UITabBarControllerDelegate {

    // MARK: - Stored properties

    var animation: Animation?
    weak var delegate: UITabBarControllerDelegate?

    // MARK: - Overrides

    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (animationController as? TransitionAnimation)?.interactive
            ?? animationController as? UIViewControllerInteractiveTransitioning
            ?? delegate?.tabBarController?(tabBarController, interactionControllerFor: animationController)
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation?.presentationAnimation
            ?? delegate?.tabBarController?(tabBarController, animationControllerForTransitionFrom: fromVC, to: toVC)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        delegate?.tabBarController?(tabBarController, didSelect: viewController)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return delegate?.tabBarController?(tabBarController, shouldSelect: viewController) ?? true
    }

    func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
        delegate?.tabBarController?(tabBarController, willBeginCustomizing: viewControllers)
    }

    func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, didEndCustomizing: viewControllers, changed: changed)
    }

    func tabBarController(_ tabBarController: UITabBarController, willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, willEndCustomizing: viewControllers, changed: changed)
    }
}

extension UITabBarController {
    internal var animationDelegate: TabBarAnimationDelegate? {
        return delegate as? TabBarAnimationDelegate
    }
}
