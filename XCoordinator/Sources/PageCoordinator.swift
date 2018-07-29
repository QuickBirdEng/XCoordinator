//
//  PageCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

open class PageCoordinator<RouteType: Route>: BaseCoordinator<RouteType, PageViewTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(pages: [Presentable], direction: UIPageViewControllerNavigationDirection) {
        super.init(initialRoute: nil)
        performTransition(.set(pages, direction: direction, animation: nil), with: TransitionOptions(animated: false))
    }
}
