//
//  TabBarAnimationDelegate.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// TabBarAnimationDelegate is used as the delegate of a TabBarCoordinator's rootViewController
/// to allow for transitions to specify transition animations.
///
/// TabBarAnimationDelegate conforms to the `UITabBarControllerDelegate` protocol
/// and is intended for use as the delegate of one tabbar controller only.
///
/// - Note:
///     Do not override the delegate of a TabBarCoordinator's rootViewController-delegate.
///     Instead use the delegate property of the TabBarCoordinator itself.
///
open class TabBarAnimationDelegate: NSObject {

    // MARK: Stored properties

    internal weak var delegate: UITabBarControllerDelegate?
}

// MARK: - UITabBarControllerDelegate

extension TabBarAnimationDelegate: UITabBarControllerDelegate {

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// - Parameters
    ///     - tabBarController: The delegate owner.
    ///     - animationController: The animationController to return the interactionController for.
    ///
    /// - Returns:
    ///     If the animationController is a `TransitionAnimation`, it returns its interactionController.
    ///     Otherwise it requests an interactionController from the TabBarCoordinator's delegate.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.tabBarController?(tabBarController, interactionControllerFor: animationController)
    }

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// - Parameters:
    ///     - tabBarController: The delegate owner.
    ///     - fromVC: The source view controller of the transition.
    ///     - toVC: The destination view controller of the transition.
    ///
    /// - Returns:
    ///     The presentation animation controller from the toVC's transitioningDelegate.
    ///     If not present, it uses the TabBarCoordinator's delegate as fallback.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        toVC.transitioningDelegate?.animationController?(forPresented: toVC, presenting: tabBarController, source: fromVC)
            ?? delegate?.tabBarController?(tabBarController, animationControllerForTransitionFrom: fromVC, to: toVC)
    }

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// This method delegates to the TabBarCoordinator's delegate.
    ///
    /// - Parameters:
    ///     - tabBarController: The delegate owner.
    ///     - viewController: The destination viewController.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               didSelect viewController: UIViewController) {
        delegate?.tabBarController?(tabBarController, didSelect: viewController)
    }

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// This method delegates to the TabBarCoordinator's delegate.
    ///
    /// - Parameters:
    ///     - tabBarController: The delegate owner.
    ///     - viewController: The destination viewController.
    ///
    /// - Returns:
    ///     The result of the TabBarCooordinator's delegate. If not specified, it returns true.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               shouldSelect viewController: UIViewController) -> Bool {
        delegate?.tabBarController?(tabBarController, shouldSelect: viewController) ?? true
    }

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// This method delegates to the TabBarCoordinator's delegate.
    ///
    /// - Parameters:
    ///     - tabBarController: The delegate owner.
    ///     - viewControllers: The source viewControllers.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               willBeginCustomizing viewControllers: [UIViewController]) {
        delegate?.tabBarController?(tabBarController, willBeginCustomizing: viewControllers)
    }

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// This method delegates to the TabBarCoordinator's delegate.
    ///
    /// - Parameters:
    ///     - tabBarController: The delegate owner.
    ///     - viewControllers: The source viewControllers.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, didEndCustomizing: viewControllers, changed: changed)
    }

    ///
    /// See [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/UITabBarControllerDelegate)
    /// for further reference.
    ///
    /// This method delegates to the TabBarCoordinator's delegate.
    ///
    /// - Parameters:
    ///     - tabBarController: The delegate owner.
    ///     - viewControllers: The source viewControllers.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, willEndCustomizing: viewControllers, changed: changed)
    }
}

extension UITabBarController {
    internal var animationDelegate: TabBarAnimationDelegate? {
        delegate as? TabBarAnimationDelegate
    }
}
