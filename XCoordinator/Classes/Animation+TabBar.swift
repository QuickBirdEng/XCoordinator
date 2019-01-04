//
//  Animation+TabBar.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// TabBarAnimationDelegate is used as the delegate of a TabBarCoordinator's rootViewController
/// to allow for transitions to specify transition animations.
///
/// This delegate is intended for use on one tab bar controller only.
/// Do not use one object as delegate of multiple tab bar controllers.
///
/// - Note:
///     Do not override the delegate of a TabBarCoordinator's rootViewController-delegate.
///     Instead use the delegate property of the TabBarCoordinator itself.
///
open class TabBarAnimationDelegate: NSObject {

    // MARK: - Stored properties

    internal var animation: Animation?
    internal weak var delegate: UITabBarControllerDelegate?
}

// MARK: - UITabBarControllerDelegate

extension TabBarAnimationDelegate: UITabBarControllerDelegate {

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter animationController:
    ///     The animationController to return the interactionController for.
    ///
    /// - Returns:
    ///     The interactionController of an animationController of type `TransitionAnimation`.
    ///     Otherwise the result of the TabBarCoordinator's delegate.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        return (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.tabBarController?(tabBarController, interactionControllerFor: animationController)
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter fromVC:
    ///     The source view controller of the transition.
    ///
    /// - Parameter toVC:
    ///     The destination view controller of the transition.
    ///
    /// - Returns:
    ///     The presentation animation of the last specified `Animation` object.
    ///     If not present, it uses the TabBarCoordinator's delegate as fallback.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation?.presentationAnimation
            ?? delegate?.tabBarController?(tabBarController, animationControllerForTransitionFrom: fromVC, to: toVC)
    }

    ///
    /// See UIKit documentation for further reference.
    /// This method delegates to the delegate specified in the TabBarCoordinator.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter viewController:
    ///     The viewController that was selected.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               didSelect viewController: UIViewController) {
        delegate?.tabBarController?(tabBarController, didSelect: viewController)
    }

    ///
    /// See UIKit documentation for further reference.
    /// This method delegates to the delegate specified in the TabBarCoordinator.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter viewController:
    ///     The viewController that may be selected.
    ///
    /// - Returns:
    ///     The result of the TabBarCooordinator's delegate. If not specified, it returns true.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               shouldSelect viewController: UIViewController) -> Bool {
        return delegate?.tabBarController?(tabBarController, shouldSelect: viewController) ?? true
    }

    ///
    /// See UIKit documentation for further reference.
    /// This method delegates to the delegate specified in the TabBarCoordinator.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter viewControllers:
    ///     The viewControllers that will begin to be customized.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               willBeginCustomizing viewControllers: [UIViewController]) {
        delegate?.tabBarController?(tabBarController, willBeginCustomizing: viewControllers)
    }

    ///
    /// See UIKit documentation for further reference.
    /// This method delegates to the delegate specified in the TabBarCoordinator.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter viewControllers:
    ///     The viewControllers that ended to be customized.
    ///
    open func tabBarController(_ tabBarController: UITabBarController,
                               didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        delegate?.tabBarController?(tabBarController, didEndCustomizing: viewControllers, changed: changed)
    }

    ///
    /// See UIKit documentation for further reference.
    /// This method delegates to the delegate specified in the TabBarCoordinator.
    ///
    /// - Parameter tabBarController:
    ///     The tabBarController to which this object is the delegate of.
    ///
    /// - Parameter viewControllers:
    ///     The viewControllers that will end to be customized.
    ///
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
