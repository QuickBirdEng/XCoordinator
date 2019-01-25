//
//  Coordinator+TabBar.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UITabBarController {
    func set(_ viewControllers: [UIViewController],
             with options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a TabBarAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `TabBarCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.setViewControllers(viewControllers, animated: options.animated)

        CATransaction.commit()
    }

    func select(_ viewController: UIViewController,
                with options: TransitionOptions,
                animation: Animation?,
                completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a TabBarAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `TabBarCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        self.rootViewController.selectedViewController = viewController

        CATransaction.commit()
    }

    func select(index: Int, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a TabBarAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `TabBarCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        self.rootViewController.selectedIndex = index

        CATransaction.commit()
    }
}
