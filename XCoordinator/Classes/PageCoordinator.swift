//
//  PageCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class PageCoordinator<RouteType: Route>: BaseCoordinator<RouteType, PageTransition> {

    // MARK: - Stored properties

    private let transitionStyle: UIPageViewController.TransitionStyle
    private let orientation: UIPageViewController.NavigationOrientation
    private let options: [UIPageViewController.OptionsKey: Any]?
    private let dataSource: PageCoordinatorDataSource

    // MARK: - Init

    public init(pages: [Presentable],
                direction: UIPageViewController.NavigationDirection = .forward,
                transitionStyle: UIPageViewController.TransitionStyle = .pageCurl,
                orientation: UIPageViewController.NavigationOrientation = .horizontal,
                options: [UIPageViewController.OptionsKey: Any]? = nil) {

        self.transitionStyle = transitionStyle
        self.orientation = orientation
        self.options = options
        self.dataSource = PageCoordinatorDataSource(pages: pages)

        if let firstPage = pages.first {
            super.init(initialTransition: .set([firstPage], direction: direction))
        } else {
            super.init(initialRoute: nil)
        }           
    }

    open override func generateRootViewController() -> UIPageViewController {
        let controller = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: orientation, options: options)
        controller.dataSource = dataSource
        controller.delegate = dataSource
        return controller
    }
}

class PageCoordinatorDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pages: [Presentable]

    init(pages: [Presentable]) {
        self.pages = pages
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let isDisplaying = pageViewController.viewControllers?.isEmpty ?? false
        return isDisplaying ? pages.count : 0
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let viewController = pageViewController.viewControllers?.first
        let index = pages.index(where: { $0.viewController == viewController })
        guard let presIndex = index else { return 0 }
        return presIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(where: { $0.viewController == viewController }) else {
            assertionFailure()
            return nil
        }
        let prevIndex = index - 1
        guard pages.indices.contains(prevIndex) else { return nil }
        return pages[prevIndex].viewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(where: { $0.viewController == viewController }) else {
            assertionFailure()
            return nil
        }
        let nextIndex = index + 1
        guard pages.indices.contains(nextIndex) else { return nil }
        return pages[nextIndex].viewController
    }
}
