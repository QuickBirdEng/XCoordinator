//
//  UITabBarController+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func set(_ viewControllers: [UIViewController],
             with options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            viewControllers.first?.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the TabBarCoordinator's
        initializer already had a delegate when initializing the TabBarCoordinator.
        To set another delegate of a rootViewController in a TabBarCoordinator, have a look at `TabBarCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            setViewControllers(viewControllers, animated: options.animated)
        }

        CATransaction.commit()
    }

    func select(_ viewController: UIViewController,
                with options: TransitionOptions,
                animation: Animation?,
                completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the TabBarCoordinator's
        initializer already had a delegate when initializing the TabBarCoordinator.
        To set another delegate of a rootViewController in a TabBarCoordinator, have a look at `TabBarCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            selectedViewController = viewController
        }

        CATransaction.commit()
    }

    func select(index: Int, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        if let animation = animation {
            viewControllers?[index].transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the TabBarCoordinator's
        initializer already had a delegate when initializing the TabBarCoordinator.
        To set another delegate of a rootViewController in a TabBarCoordinator, have a look at `TabBarCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            selectedIndex = index
        }

        CATransaction.commit()
    }
    
}
