//
//  UIPageViewController+Configuration.swift
//  XCoordinator
//
//  Created by Paul Kraft on 14.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension UIPageViewController {

    ///
    /// Creates a `UIPageViewController` on the basis of the parameters specified when creating the configuration.
    ///
    /// - Parameter configuration:
    ///     The initial configuration of the `UIPageViewController`.
    ///
    public convenience init(configuration: Configuration) {
        self.init(
            transitionStyle: configuration.transitionStyle,
            navigationOrientation: configuration.navigationOrientation,
            options: configuration.options
        )
    }

    ///
    /// Configuration is used to wrap different configuration options of a `UIPageViewController`.
    ///
    /// It provides customization options for the transitionStyle, navigationOrientation and further options.
    ///
    /// - Note:
    ///     Read the [UIPageViewController documentation](https://developer.apple.com/documentation/uikit/UIPageViewController)
    ///     to get further information on the implications of these configuration options.
    ///
    public struct Configuration {

        /// The transitionStyle of the `UIPageViewController`, e.g. pageCurl or scroll.
        public let transitionStyle: TransitionStyle

        /// The navigationOrientation of the `UIPageViewController`, e.g. horizontal or vertical.
        public let navigationOrientation: NavigationOrientation

        /// Further options to customize the `UIPageViewController`.
        public let options: [UIPageViewController.OptionsKey: Any]?

        ///
        /// Creates a UIPageViewController.Configuration struct to be used to initialize a `UIPageViewController`.
        ///
        /// - Parameters:
        ///     - transitionStyle:
        ///         The transitionStyle of the `UIPageViewController`, e.g. pageCurl or scroll.
        ///     - navigationOrientation:
        ///         The navigationOrientation of the `UIPageViewController`, e.g. horizontal or vertical.
        ///     - options:
        ///         Further options to customize the `UIPageViewController`.
        ///
        public init(transitionStyle: TransitionStyle = .pageCurl,
                    navigationOrientation: NavigationOrientation = .horizontal,
                    options: [UIPageViewController.OptionsKey: Any]? = nil) {
            self.transitionStyle = transitionStyle
            self.navigationOrientation = navigationOrientation
            self.options = options
        }

        /// The default configuration of a `UIPageViewController` as specified in UIKit.
        public static var `default` = Configuration()
    }
}
