//
//  PageCoordinatorDataSource.swift
//  XCoordinator
//
//  Created by Paul Kraft on 14.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class PageCoordinatorDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Stored properties

    open private(set) var pages: [UIViewController]
    open private(set) var loop: Bool

    // MARK: - Init

    public init(pages: [UIViewController], loop: Bool) {
        self.pages = pages
        self.loop = loop
    }

    // MARK: - Methods

    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let isNotDisplaying = pageViewController.viewControllers?.isEmpty ?? true
        return isNotDisplaying ? 0 : pages.count
    }

    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first else { return 0 }
        return pages.firstIndex(of: viewController) ?? 0
    }

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
