//
//  File.swift
//  
//
//  Created by Paul Kraft on 09.05.23.
//

import UIKit

public struct PageSet<RootViewController> {

    // MARK: Stored Properties

    private let primary: () -> any Presentable
    private let secondary: () -> (any Presentable)?
    private let direction: UIPageViewController.NavigationDirection

    // MARK: Initialization

    public init(direction: UIPageViewController.NavigationDirection, primary: @escaping () -> any Presentable, secondary: @escaping () -> (any Presentable)? = { nil }) {
        self.primary = primary
        self.secondary = secondary
        self.direction = direction
    }

}

extension PageSet: TransitionComponent where RootViewController: UIPageViewController {

    public func build() -> Transition<RootViewController> {
        let presentables = [primary(), secondary()].compactMap { $0 }
        return Transition(presentables: presentables,
                          animationInUse: nil
        ) { rootViewController, options, completion in
            let viewControllers = presentables.map { $0.viewController! }
            rootViewController.isDoubleSided = viewControllers.count > 1
            rootViewController.setViewControllers(
                viewControllers,
                direction: direction,
                animated: options.animated
            ) { _ in
                presentables.forEach { $0.presented(from: rootViewController) }
                completion?()
            }
        }
    }

}
