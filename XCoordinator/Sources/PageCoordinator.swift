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

    // MARK: - Init

    public init(pages: [Presentable]? = nil,
                direction: UIPageViewControllerNavigationDirection = .forward,
                transitionStyle: UIPageViewControllerTransitionStyle = .pageCurl,
                orientation: UIPageViewControllerNavigationOrientation = .horizontal,
                options: [String: Any]? = nil) {

        self.transitionStyle = transitionStyle
        self.orientation = orientation
        self.options = options

        if let pages = pages {
            super.init(initialTransition: .set(pages, direction: direction))
        } else {
            super.init(initialTransition: nil)
        }
    }

    open override func generateRootViewController() -> UIPageViewController {
        return UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: orientation, options: options)
    }
}
