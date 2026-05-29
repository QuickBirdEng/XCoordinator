//
//  PageSetReliably.swift
//  XCoordinator
//
//  Created by Paul Kraft on 09.05.23.
//

import UIKit

///
/// A drop-in replacement for ``PageSet`` (single page) that **always** calls its completion handler.
///
/// `UIPageViewController.setViewControllers(_:direction:animated:completion:)` silently skips its
/// completion block when the requested page is already the one on-screen (a long-standing UIKit quirk).
/// `deepLink` chains the next route *inside* a transition's completion, so a deep link whose page step
/// targets the already-visible page would stall forever. This component short-circuits the no-op case
/// and invokes the completion directly, so deep links (and any chained transitions) keep flowing.
///
public struct PageSetReliably<RootViewController> {

    // MARK: Stored Properties

    private let page: () -> any Presentable
    private let direction: UIPageViewController.NavigationDirection

    // MARK: Initialization

    public init(direction: UIPageViewController.NavigationDirection,
                page: @escaping () -> any Presentable) {
        self.page = page
        self.direction = direction
    }

}

extension PageSetReliably: TransitionComponent where RootViewController: UIPageViewController {

    public func build() -> Transition<RootViewController> {
        let presentable = page()
        return Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            guard let target = presentable.viewController else {
                completion?()
                return
            }
            let isAlreadyVisible = rootViewController.viewControllers?.count == 1
                && rootViewController.viewControllers?.first === target
            guard !isAlreadyVisible else {
                // The page is already displayed — UIKit would not call the completion, so do it ourselves.
                // `presented(from:)` was already invoked when this page was first set, so it is not repeated.
                completion?()
                return
            }
            rootViewController.setViewControllers([target], direction: direction, animated: options.animated) { _ in
                presentable.presented(from: rootViewController)
                completion?()
            }
        }
    }

}
