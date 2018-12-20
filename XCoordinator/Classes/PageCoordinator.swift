//
//  PageCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class PageCoordinator<RouteType: Route>: BaseCoordinator<RouteType, PageTransition> {

    // MARK: - Stored properties

    public let dataSource: PageCoordinatorDataSource
    public let configuration: UIPageViewController.Configuration

    // MARK: - Init

    public init(pages: [Presentable],
                loop: Bool = false,
                set: Presentable? = nil,
                direction: UIPageViewController.NavigationDirection = .forward,
                configuration: UIPageViewController.Configuration = .default) {
        self.dataSource = PageCoordinatorDataSource(pages: pages.map { $0.viewController }, loop: loop)
        self.configuration = configuration

        guard let firstPage = set ?? pages.first else {
            assertionFailure("Please provide a positive number of pages for use in \(String(describing: PageCoordinator<RouteType>.self))")
            super.init(initialRoute: nil)
            return
        }

        super.init(initialTransition: .set(firstPage, direction: direction))
    }

    // MARK: - Overrides

    open override func generateRootViewController() -> UIPageViewController {
        let controller = UIPageViewController(configuration: configuration)
        controller.dataSource = dataSource
        controller.delegate = dataSource
        return controller
    }
}
