//
//  Coordinator+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//



extension TransitionPerformer where TransitionType.RootViewController: UINavigationController {
    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let visibleViewController = rootViewController.visibleViewController ?? rootViewController
        visibleViewController.transitioningDelegate = animation

        rootViewController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let visibleViewController = rootViewController.visibleViewController ?? rootViewController
        visibleViewController.transitioningDelegate = animation

        if toRoot {
            rootViewController.popToRootViewController(animated: options.animated)
        } else {
            rootViewController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }

    func set(_ viewControllers: [UIViewController], with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let visibleViewController = rootViewController.visibleViewController ?? rootViewController
        visibleViewController.transitioningDelegate = animation

        rootViewController.setViewControllers(viewControllers, animated: options.animated)

        CATransaction.commit()
    }

    func pop(to viewController: UIViewController, options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.visibleViewController?.transitioningDelegate = animation
        rootViewController.popToViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }
}
