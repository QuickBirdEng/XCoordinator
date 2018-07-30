//
//  PageCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

open class PageCoordinator<RouteType: Route>: BaseCoordinator<RouteType, PageViewTransition> {

    // MARK: - Stored properties

    private let transitionStyle: UIPageViewControllerTransitionStyle
    private let orientation: UIPageViewControllerNavigationOrientation
    private let options: [String: Any]?
    private let dataSource: PageCoordinatorDataSource

    // MARK: - Init

    public init(pages: [Presentable],
                direction: UIPageViewControllerNavigationDirection = .forward,
                transitionStyle: UIPageViewControllerTransitionStyle = .pageCurl,
                orientation: UIPageViewControllerNavigationOrientation = .horizontal,
                options: [String: Any]? = nil) {

        self.transitionStyle = transitionStyle
        self.orientation = orientation
        self.options = options
        self.dataSource = PageCoordinatorDataSource(pages: pages)

        if let first = pages.first {
            super.init(initialTransition: .set([first], direction: direction))
        } else {
            super.init(initialRoute: nil)
        }

        rootViewController.loadViewIfNeeded()
    }

    open override func presented(from presentable: Presentable?) {
        // Not releasing page view controller here
    }

    open override func generateRootViewController() -> UIPageViewController {
        print(#function)
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
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print(#function)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print(#function)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let isDisplaying = pageViewController.viewControllers?.first != nil
        let count = pages.count
        print(#function, count)
        return isDisplaying ? count : 0
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let viewController = pageViewController.viewControllers?.first
        let index = pages.index(where: { $0.viewController == viewController })
        guard let presIndex = index else {
            print("\(#function) \(viewController?.description ?? "nil")")
            return 0
        }
        print(#function, presIndex)
        return presIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(#function)
        guard let index = pages.index(where: { $0.viewController == viewController }) else {
            assertionFailure()
            return nil
        }
        let prevIndex = index - 1
        guard pages.indices.contains(prevIndex) else { return nil }
        return pages[prevIndex].viewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(#function)
        guard let index = pages.index(where: { $0.viewController == viewController }) else {
            assertionFailure()
            return nil
        }
        let nextIndex = index + 1
        guard pages.indices.contains(nextIndex) else { return nil }
        return pages[nextIndex].viewController
    }
}
