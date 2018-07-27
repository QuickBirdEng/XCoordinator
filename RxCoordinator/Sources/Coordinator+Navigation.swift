//
//  Coordinator+Navigation.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import UIKit

extension Coordinator where Self.CoordinatorRoute.TransitionType == NavigationTransition {
    var navigationController: UINavigationController {
        return viewController as! UINavigationController
    }

    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        viewController.transitioningDelegate = animation
        navigationController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(with options: TransitionOptions, toRoot: Bool, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let currentVC = navigationController.visibleViewController
        currentVC?.transitioningDelegate = animation
        if toRoot {
            navigationController.popToRootViewController(animated: options.animated)
        } else {
            navigationController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }
}
