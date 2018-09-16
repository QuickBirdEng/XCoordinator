//
//  PageViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//

public typealias PageTransition = Transition<UIPageViewController>

extension Transition where RootViewController: UIPageViewController {
    public static func set(_ presentables: [Presentable], direction: UIPageViewControllerNavigationDirection, animation: Animation? = nil) -> PageTransition {
        return PageTransition(presentable: nil) { options, performer, completion in
            performer.set(presentables.map { $0.viewController }, direction: direction, with: options, animation: animation, completion: completion)
        }
    }
}
