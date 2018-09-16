//
//  Coordinator+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//



extension TransitionPerformer where TransitionType.RootViewController: UINavigationController {
    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.empty {
            CATransaction.execute({
                self.rootViewController.pushViewController(viewController, animated: options.animated)
            }, completion: completion)
        }
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.empty {
            CATransaction.execute({
                if toRoot {
                    self.rootViewController.popToRootViewController(animated: options.animated)
                } else {
                    self.rootViewController.popViewController(animated: options.animated)
                }
            }, completion: completion)
        }
    }

    func set(_ viewControllers: [UIViewController], with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animation = animation
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.empty {
            CATransaction.execute({
                self.rootViewController.setViewControllers(viewControllers, animated: options.animated)
            }, completion: completion)
        }
    }
}
