//
//  UIPageViewController+Configuration.swift
//  XCoordinator
//
//  Created by Paul Kraft on 14.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension UIPageViewController {
    public convenience init(configuration: Configuration) {
        self.init(
            transitionStyle: configuration.transitionStyle,
            navigationOrientation: configuration.navigationOrientation,
            options: configuration.options
        )
    }

    public struct Configuration {
        public let transitionStyle: TransitionStyle
        public let navigationOrientation: NavigationOrientation
        public let options: [UIPageViewController.OptionsKey: Any]?

        public init(transitionStyle: TransitionStyle = .pageCurl,
                    navigationOrientation: NavigationOrientation = .horizontal,
                    options: [UIPageViewController.OptionsKey: Any]? = nil) {
            self.transitionStyle = transitionStyle
            self.navigationOrientation = navigationOrientation
            self.options = options
        }

        public static var `default` = Configuration()
    }
}
