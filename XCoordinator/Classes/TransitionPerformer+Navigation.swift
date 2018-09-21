//
//  Coordinator+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//



extension TransitionPerformer where TransitionType.RootViewController: UINavigationController {
    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.transitioningDelegate = animation
        rootViewController.topViewController?.transitioningDelegate = animation
        rootViewController.visibleViewController?.transitioningDelegate = animation
        viewController.transitioningDelegate = animation
        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.transitioningDelegate = animation
        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.topViewController?.transitioningDelegate = animation
        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.visibleViewController?.transitioningDelegate = animation
        if toRoot {
            self.rootViewController.popToRootViewController(animated: options.animated)
        } else {
            self.rootViewController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }

    func set(_ viewControllers: [UIViewController], with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.transitioningDelegate = animation
        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.topViewController?.transitioningDelegate = animation
        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.setViewControllers(viewControllers, animated: options.animated)

        CATransaction.commit()
    }
}
