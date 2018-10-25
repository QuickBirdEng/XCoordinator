//
//  Coordinator+PageView.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UIPageViewController {
    // animate using delegate on UIPageViewController
    func set(_ viewControllers: [UIViewController], direction: UIPageViewController.NavigationDirection, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        // TODO: Use animation
        rootViewController.setViewControllers(
            viewControllers,
            direction: direction,
            animated: options.animated,
            completion: { _ in completion?() }
        )
    }
}
