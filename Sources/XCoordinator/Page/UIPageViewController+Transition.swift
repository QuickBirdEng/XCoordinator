//
//  UIPageViewController+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension UIPageViewController {
    func set(_ viewControllers: [UIViewController],
             direction: UIPageViewController.NavigationDirection,
             with options: TransitionOptions,
             completion: PresentationHandler?) {
        isDoubleSided = viewControllers.count > 1
        setViewControllers(
            viewControllers,
            direction: direction,
            animated: options.animated,
            completion: { _ in completion?() }
        )
    }
}
