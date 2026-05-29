//
//  PageViewTransition.swift
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
        Transition {
            PageSet(direction: direction) {
                first
            } secondary: {
                second
            }
        }
    }

    ///
    /// A reliable variant of ``set(_:_:direction:)`` for a single page that **always** calls its completion
    /// handler — even when the requested page is already on-screen.
    ///
    /// `UIPageViewController` skips its completion block when asked to set the page it is already showing,
    /// which stalls `deepLink` (it chains the next route inside the completion). Use this in a deep-link
    /// chain whose page step might target the currently-visible page.
    ///
    /// - Parameters:
    ///     - page: The page to show.
    ///     - direction: The direction in which the transition should be animated.
    ///
    public static func setReliably(_ page: any Presentable,
                                   direction: UIPageViewController.NavigationDirection) -> Transition {
        Transition {
            PageSetReliably(direction: direction) {
                page
            }
        }
    }

    static func initial(pages: [any Presentable]) -> Transition {
        Transition {
            PageSetInitial {
                pages
            }
        }
    }

}
