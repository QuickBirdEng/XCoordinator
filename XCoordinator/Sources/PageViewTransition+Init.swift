//
//  PageViewTransition+Init.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

extension PageViewTransition {
    public static func set(_ presentables: [Presentable], direction: UIPageViewControllerNavigationDirection, animation: Animation? = nil) -> PageViewTransition {
        return PageViewTransition(type: .set(presentables, direction: direction), animation: animation)
    }

    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> PageViewTransition {
        return PageViewTransition(type: .present(presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> PageViewTransition {
        return PageViewTransition(type: .embed(presentable, in: container), animation: nil)
    }

    public static func dismiss(animation: Animation? = nil) -> PageViewTransition {
        return PageViewTransition(type: .dismiss, animation: animation)
    }

    public static func none() -> PageViewTransition {
        return PageViewTransition(type: .none, animation: nil)
    }
}
