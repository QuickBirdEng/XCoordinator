//
//  PageCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// PageCoordinator provides a base class for your custom coordinator with a `UIPageViewController` rootViewController.
///
/// - Note:
///     PageCoordinator sets the dataSource of the rootViewController to reflect the parameters in the initializer.
///
open class PageCoordinator<RouteType: Route>: BaseCoordinator<RouteType, PageTransition> {

    // MARK: Stored properties

    ///
    /// The dataSource of the rootViewController.
    ///
    /// Feel free to change the pages at runtime. To reflect the changes in the rootViewController, perform a `set` transition as well.
    ///
    public let dataSource: UIPageViewControllerDataSource

    // MARK: Initialization

    ///
    /// Creates a PageCoordinator with several sequential (potentially looping) pages.
    ///
    /// It further sets the current page of the rootViewController animated in the specified direction.
    ///
    /// - Note:
    ///     If you need custom configuration of the rootViewController, modify the `configuration` parameter,
    ///     since you cannot change this after the initialization.
    ///
    /// - Parameters:
    ///     - pages:
    ///         The pages of the PageCoordinator.
    ///         These can be changed later, if necessary, using the `PageCoordinator.dataSource` property.
    ///     - loop:
    ///         Whether or not the PageCoordinator should loop when hitting the end or the beginning of the specified pages.
    ///     - set:
    ///         The presentable to be shown right from the start.
    ///         This should be one of the elements of the specified pages.
    ///         If not specified, no `set` transition is triggered, which results in the first page being shown.
    ///     - direction:
    ///         The direction in which the transition to set the specified first page (parameter `set`) should be animated in.
    ///         If you specify `nil` for `set`, this parameter is ignored.
    ///     - configuration:
    ///         The configuration of the rootViewController. You cannot change this configuration later anymore (Limitation of UIKit).
    ///
    public init(rootViewController: RootViewController = .init(),
                pages: [Presentable],
                loop: Bool = false,
                set firstPage: (any Presentable)? = nil,
                _ secondPage: (any Presentable)? = nil,
                direction: UIPageViewController.NavigationDirection = .forward) {
        self.dataSource = PageCoordinatorDataSource(pages: pages.map { $0.viewController }, loop: loop)
        rootViewController.dataSource = dataSource

        let setInitialPages = [firstPage, secondPage].compactMap { $0 }
        let initialPages = setInitialPages.isEmpty ? Array(pages.prefix(rootViewController.isDoubleSided ? 2 : 1)) : setInitialPages
        guard let firstPage = initialPages.first else {
            assertionFailure("Please provide a positive number of pages for use in \(String(describing: PageCoordinator<RouteType>.self))")
            super.init(rootViewController: rootViewController, initialTransition: .initial(pages: pages))
            return
        }

        super.init(rootViewController: rootViewController,
                   initialTransition: .multiple(.initial(pages: pages), .set(firstPage, initialPages.count > 1 ? initialPages[1] : nil, direction: direction)))
    }

    ///
    /// Creates a PageCoordinator with a custom dataSource.
    /// It further sets the currently shown page and a direction for the animation of displaying it.
    /// If you need custom configuration of the rootViewController, modify the `configuration` parameter,
    /// since you cannot change this after the initialization.
    ///
    /// - Parameters:
    ///     - dataSource:
    ///         The dataSource of the PageCoordinator.
    ///     - set:
    ///         The presentable to be shown right from the start.
    ///         This should be one of the elements of the specified pages.
    ///         If not specified, no `set` transition is triggered, which results in the first page being shown.
    ///     - direction:
    ///         The direction in which the transition to set the specified first page (parameter `set`) should be animated in.
    ///         If you specify `nil` for `set`, this parameter is ignored.
    ///     - configuration:
    ///         The configuration of the rootViewController. You cannot change this configuration later anymore (Limitation of UIKit).
    ///
    public init(rootViewController: RootViewController = .init(),
                dataSource: UIPageViewControllerDataSource,
                set firstPage: any Presentable,
                _ secondPage: (any Presentable)? = nil,
                direction: UIPageViewController.NavigationDirection) {
        self.dataSource = dataSource
        rootViewController.dataSource = dataSource
        super.init(rootViewController: rootViewController,
                   initialTransition: .set(firstPage, secondPage, direction: direction))
    }

    public convenience init(
        transitionStyle: UIPageViewController.TransitionStyle = .pageCurl,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        isDoubleSided: Bool = false,
        spineLocation: UIPageViewController.SpineLocation? = nil,
        interPageSpacing: CGFloat? = nil,
        pages: [any Presentable],
        loop: Bool = false,
        set firstPage: (any Presentable)? = nil,
        _ secondPage: (any Presentable)? = nil,
        direction: UIPageViewController.NavigationDirection = .forward
    ) {
        var options = [UIPageViewController.OptionsKey: Any]()
        options[.spineLocation] = (spineLocation ?? (isDoubleSided ? .mid : nil))?.rawValue
        options[.interPageSpacing] = interPageSpacing

        let rootViewController = UIPageViewController(
            transitionStyle: transitionStyle,
            navigationOrientation: navigationOrientation,
            options: options.isEmpty ? nil : options
        )
        rootViewController.isDoubleSided = isDoubleSided

        self.init(
            rootViewController: rootViewController,
            pages: pages,
            loop: loop,
            set: firstPage,
            secondPage,
            direction: direction
        )
    }

}
