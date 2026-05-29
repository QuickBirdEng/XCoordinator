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
open class PageCoordinator<RouteType: Route>: BaseCoordinator<RouteType, UIPageViewController> {

    // MARK: Stored properties

    ///
    /// The dataSource of the rootViewController.
    ///
    /// Feel free to change the pages at runtime. To reflect the changes in the rootViewController, perform a `set` transition as well.
    ///
    public let dataSource: UIPageViewControllerDataSource

    // MARK: Initialization

    // Note: PageCoordinator intentionally does NOT expose BaseCoordinator's bare
    // `init(rootViewController:initialRoute:)` / `init(rootViewController:initialTransition:)` inits.
    // A page view controller needs a `dataSource` to drive swipe navigation, and that `dataSource`
    // is fixed at init — so every PageCoordinator must be built with `pages:` or `dataSource:` below.

    ///
    /// Creates a PageCoordinator with several sequential (potentially looping) pages.
    ///
    /// If neither `firstPage` nor `secondPage` is specified, the coordinator falls back to showing the
    /// first one or two of `pages` (depending on whether the page view controller is double-sided).
    ///
    /// - Parameters:
    ///   - rootViewController: The `UIPageViewController` to host pages. Defaults to a fresh instance.
    ///     Note that you cannot change its transition style / navigation orientation / options after
    ///     initialization — use the convenience initializer to configure those up front.
    ///   - pages: The pages of the PageCoordinator. These can be changed later via ``dataSource``.
    ///   - loop: Whether the coordinator should loop when reaching the end or the beginning of `pages`.
    ///   - firstPage: The page to show on appearance. Must be an element of `pages`. If `nil`, falls back
    ///     to the first page (or first two for double-sided controllers).
    ///   - secondPage: The second page when the page view controller is double-sided. Optional.
    ///   - direction: Animation direction for the initial set transition. Ignored if no initial page is set.
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
    ///
    /// - Parameters:
    ///   - rootViewController: The `UIPageViewController` to host pages. Defaults to a fresh instance.
    ///   - dataSource: The dataSource to drive page navigation.
    ///   - firstPage: The page to show on appearance.
    ///   - secondPage: The second page when the page view controller is double-sided. Optional.
    ///   - direction: Animation direction for the initial set transition.
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

    ///
    /// Creates a PageCoordinator and its underlying `UIPageViewController` up front, letting you configure
    /// the controller's transition style, orientation, double-sided mode, spine location, and inter-page spacing.
    ///
    /// - Parameters:
    ///   - transitionStyle: The style used to transition between pages.
    ///   - navigationOrientation: Horizontal or vertical page navigation.
    ///   - isDoubleSided: Whether the page view controller renders two pages at once.
    ///   - spineLocation: The spine location for double-sided controllers. Defaults to `.mid` when
    ///     `isDoubleSided` is true and `nil` otherwise.
    ///   - interPageSpacing: The spacing between adjacent pages.
    ///   - pages: The pages of the PageCoordinator.
    ///   - loop: Whether the coordinator should loop at the end and the beginning of `pages`.
    ///   - firstPage: The page to show on appearance. See ``init(rootViewController:pages:loop:set:_:direction:)``
    ///     for the fallback behaviour when `firstPage` is `nil`.
    ///   - secondPage: The second page when `isDoubleSided` is true. Optional.
    ///   - direction: Animation direction for the initial set transition.
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
