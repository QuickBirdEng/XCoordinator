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
        assert(animation == nil || rootViewController.animationDelegate != nil)

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
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        self.rootViewController.selectedViewController = viewController

        CATransaction.commit()
    }

    func select(index: Int, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        self.rootViewController.selectedIndex = index

        CATransaction.commit()
    }
}
