//
//  PageViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

/// PageTransition describes transitions that can be used
/// with a `UIPageViewController` rootViewController.
public typealias PageTransition = Transition<UIPageViewController>

extension Transition where RootViewController: UIPageViewController {

    ///
    /// Sets the current page(s) of the rootViewController. Make sure to set
    /// `UIPageViewController.isDoubleSided` to the appropriate setting before executing this transition.
    ///
    /// - Parameter first:
    ///     The first page being shown. If second is specified as `nil`, this reflects a single page
    ///     being shown.
    ///
    /// - Parameter second:
    ///     The second page being shown. This page is optional, as your rootViewController can be used
    ///     with `isDoubleSided` enabled or not.
    ///
    /// - Parameter direction:
    ///     The direction in which the transition should be animated.
    ///
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

    static func initial(pages: [Presentable]) -> Transition {
        return Transition(presentables: pages, animation: nil) { _, performer, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                pages.forEach { $0.presented(from: performer) }
                completion?()
            }
            CATransaction.commit()
        }
    }
}
