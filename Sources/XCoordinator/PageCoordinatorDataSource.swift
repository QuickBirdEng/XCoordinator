//
//  PageCoordinatorDataSource.swift
//  XCoordinator
//
//  Created by Paul Kraft on 14.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// PageCoordinatorDataSource is a
/// [UIPageViewControllerDataSource](https://developer.apple.com/documentation/uikit/UIPageViewControllerDataSource)
/// implementation with a rather static list of pages.
///
/// It further allows looping through the given pages. When looping is active the pages are wrapped around in the given presentables array.
/// When the user navigates beyond the end of the specified pages, the pages are wrapped around by displaying the first page.
/// In analogy to that, it also wraps to the last page when navigating beyond the beginning.
///
open class PageCoordinatorDataSource: NSObject, UIPageViewControllerDataSource {

    // MARK: Stored properties

    /// The pages of the `UIPageViewController` in sequential order.
    open var pages: [UIViewController]

    /// Whether or not the pages of the `UIPageViewController` should be in a loop,
    /// i.e. whether a swipe to the left of the last page should result in the first page being shown
    /// (or the last shown when swiping right on the first page)
    open var loop: Bool

    // MARK: Initialization

    ///
    /// Creates a PageCoordinatorDataSource with the given pages and looping capabilities.
    ///
    /// - Parameters:
    ///     - pages:
    ///         The pages to be shown in the `UIPageViewController`.
    ///     - loop:
    ///         Whether or not the pages of the `UIPageViewController` should be in a loop,
    ///         i.e. whether a swipe to the left of the last page should result in the first page being shown
    ///         (or the last shown when swiping right on the first page)
    ///         If you specify `false` here, the user cannot swipe left on the last page and right on the first.
    ///
    public init(pages: [UIViewController], loop: Bool) {
        self.pages = pages
        self.loop = loop
    }

    // MARK: Methods

    ///
    /// See [UIPageViewControllerDataSource](https://developer.apple.com/documentation/uikit/UIPageViewControllerDataSource)
    /// for further information.
    ///
    /// - Parameter pageViewController:
    ///     The dataSource owner.
    ///
    /// - Returns:
    ///     The count of `pages`, if it is displayed. Otherwise 0.
    ///
    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let isNotDisplaying = pageViewController.viewControllers?.isEmpty ?? true
        return isNotDisplaying ? 0 : pages.count
    }

    ///
    /// See [UIPageViewControllerDataSource](https://developer.apple.com/documentation/uikit/UIPageViewControllerDataSource)
    /// for further information.
    ///
    /// - Parameter pageViewController:
    ///     The dataSource owner.
    ///
    /// - Returns:
    ///     The index of the currently visible view controller.
    ///
    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first else { return 0 }
        return pages.firstIndex(of: viewController) ?? 0
    }

    ///
    /// See [UIPageViewControllerDataSource](https://developer.apple.com/documentation/uikit/UIPageViewControllerDataSource)
    /// for further information.
    ///
    /// This method first searches for the index of the given viewController in the `pages` array.
    /// It then tries to find a viewController at the preceding position by potentially looping.
    ///
    /// - Parameters:
    ///     - pageViewController: The dataSource owner.
    ///     - viewController: The viewController to find the preceding viewController of.
    ///
    /// - Returns:
    ///     The preceding viewController.
    ///
    open func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            // swiftlint:disable:next line_length
            assertionFailure("\(String(describing: UIPageViewController.self)) is displaying viewController not available in the provided pages-array.")
            return nil
        }
        let prevIndex = index - 1
        guard prevIndex >= 0 else { return loop ? pages.last?.viewController : nil }
        return pages[prevIndex].viewController
    }

    ///
    /// See [UIPageViewControllerDataSource](https://developer.apple.com/documentation/uikit/UIPageViewControllerDataSource)
    /// for further information.
    ///
    /// This method first searches for the index of the given viewController in the `pages` array.
    /// It then tries to find a viewController at the following position by potentially looping.
    ///
    /// - Parameters:
    ///     - pageViewController: The dataSource owner.
    ///     - viewController: The viewController to find the following viewController of.
    ///
    /// - Returns:
    ///     The following viewController.
    ///
    open func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            // swiftlint:disable:next line_length
            assertionFailure("\(String(describing: UIPageViewController.self)) is displaying viewController not available in the provided pages-array.")
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex < pages.count else { return loop ? pages.first?.viewController : nil }
        return pages[nextIndex].viewController
    }
}
