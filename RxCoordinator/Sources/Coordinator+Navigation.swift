//
//  Coordinator+Navigation.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import UIKit

extension Coordinator where Self.TransitionType == NavigationTransition {
    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        viewController.transitioningDelegate = animation
        rootViewController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(with options: TransitionOptions, toRoot: Bool, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let currentVC = rootViewController.visibleViewController
        currentVC?.transitioningDelegate = animation
        if toRoot {
            rootViewController.popToRootViewController(animated: options.animated)
        } else {
            rootViewController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }
}
