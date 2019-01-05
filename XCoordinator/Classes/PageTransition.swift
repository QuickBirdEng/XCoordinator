//
//  PageViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias PageTransition = Transition<UIPageViewController>

extension Transition where RootViewController: UIPageViewController {
    public static func set(_ first: Presentable, _ second: Presentable? = nil,
                           direction: UIPageViewController.NavigationDirection) -> PageTransition {
        let presentables = [first, second].compactMap { $0 }
        return PageTransition(presentables: presentables, animation: nil) { options, performer, completion in
            performer.set(presentables.map { $0.viewController },
                          direction: direction,
                          with: options
            ) {
                presentables.forEach { $0.presented(from: performer) }
                completion?()
            }
        }
    }
}
