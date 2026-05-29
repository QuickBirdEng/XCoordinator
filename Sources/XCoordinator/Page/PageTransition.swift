//
//  PageTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

/// PageTransition offers transitions that can be used
/// with a `UIPageViewController` rootViewController.
public typealias PageTransition = Transition<UIPageViewController>

extension Transition where RootViewController: UIPageViewController {

    ///
    /// Sets the current page(s) of the rootViewController. Make sure to set
    /// `UIPageViewController.isDoubleSided` to the appropriate setting before executing this transition.
    ///
    /// - Parameters:
    ///     - first:
    ///         The first page being shown. If second is specified as `nil`, this reflects a single page
    ///         being shown.
    ///     - second:
    ///         The second page being shown. This page is optional, as your rootViewController can be used
    ///         with `isDoubleSided` enabled or not.
    ///     - direction:
    ///         The direction in which the transition should be animated.
    ///
    public static func set(_ first: any Presentable, _ second: (any Presentable)? = nil,
                           direction: UIPageViewController.NavigationDirection) -> Transition {
        let presentables = [first, second].compactMap { $0 }
        return Transition(presentables: presentables, animationInUse: nil) { rootViewController, options, completion in
            let viewControllers: [UIViewController] = presentables.map { $0.viewController }
            rootViewController.isDoubleSided = viewControllers.count > 1

            // `UIPageViewController.setViewControllers(_:direction:animated:completion:)` skips its completion
            // block when asked to display the pages it is already showing (a long-standing UIKit quirk).
            // `deepLink` chains the next route inside this completion, so short-circuit the no-op case and
            // invoke the completion ourselves to keep chained transitions flowing. `presented(from:)` already
            // fired when these pages were first set, so it is not repeated here.
            guard rootViewController.viewControllers != viewControllers else {
                completion?()
                return
            }

            rootViewController.setViewControllers(
                viewControllers,
                direction: direction,
                animated: options.animated
            ) { _ in
                presentables.forEach { $0.presented(from: rootViewController) }
                completion?()
            }
        }
    }

    static func initial(pages: [any Presentable]) -> Transition {
        Transition(presentables: pages, animationInUse: nil) { rootViewController, _, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                pages.forEach { $0.presented(from: rootViewController) }
                completion?()
            }
            CATransaction.commit()
        }
    }

}
