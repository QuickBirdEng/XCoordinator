//
//  Coordinator+TabBar.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UITabBarController {
    func set(_ viewControllers: [UIViewController], with options: TransitionOptions, completion: PresentationHandler?) {

        CATransaction.execute({
            self.rootViewController.setViewControllers(viewControllers, animated: options.animated)
        }, completion: completion)
    }

    func select(_ viewController: UIViewController, with options: TransitionOptions, completion: PresentationHandler?) {

        CATransaction.execute({
            self.rootViewController.selectedViewController = viewController
        }, completion: completion)
    }

    func select(index: Int, with options: TransitionOptions, completion: PresentationHandler?) {

        CATransaction.execute({
            self.rootViewController.selectedIndex = index
        }, completion: completion)
    }
}
