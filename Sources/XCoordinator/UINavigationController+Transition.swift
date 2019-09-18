//
//  UINavigationController+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func push(_ viewController: UIViewController,
              with options: TransitionOptions,
              animation: Animation?,
              completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            pushViewController(viewController, animated: options.animated)
        }

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        if let animation = animation {
            topViewController?.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            if toRoot {
                popToRootViewController(animated: options.animated)
            } else {
                popViewController(animated: options.animated)
            }
        }

        CATransaction.commit()
    }

    func set(_ viewControllers: [UIViewController],
             with options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            viewControllers.last?.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let animation = animation {
                viewControllers.forEach { $0.transitioningDelegate = animation }
            }
            completion?()
        }

        autoreleasepool {
            setViewControllers(viewControllers, animated: options.animated)
        }

        CATransaction.commit()
    }

    func pop(to viewController: UIViewController,
             options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            topViewController?.transitioningDelegate = animation
            viewController.transitioningDelegate = animation
        }

        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            _ = popToViewController(viewController, animated: options.animated)
        }

        CATransaction.commit()
    }
    
}
