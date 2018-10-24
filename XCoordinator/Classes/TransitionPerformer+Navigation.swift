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
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            self.rootViewController.pushViewController(viewController, animated: options.animated)

            CATransaction.commit()
        }

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            if toRoot {
                self.rootViewController.popToRootViewController(animated: options.animated)
            } else {
                self.rootViewController.popViewController(animated: options.animated)
            }

            CATransaction.commit()
        }

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }

    func set(_ viewControllers: [UIViewController], with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            self.rootViewController.setViewControllers(viewControllers, animated: options.animated)

            CATransaction.commit()
        }

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }

    func pop(to viewController: UIViewController, options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            self.rootViewController.popToViewController(viewController, animated: options.animated)

            CATransaction.commit()
        }

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }
}
