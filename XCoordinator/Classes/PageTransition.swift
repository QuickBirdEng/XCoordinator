//
//  PageViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias PageTransition = Transition<UIPageViewController>

extension Transition where RootViewController: UIPageViewController {
    public static func set(_ presentables: [Presentable], direction: UIPageViewControllerNavigationDirection) -> PageTransition {
        return PageTransition(presentable: nil) { options, performer, completion in
            performer.set(
                presentables.map { $0.viewController },
                direction: direction,
                with: options,
                completion: completion
            )
        }
    }
}
