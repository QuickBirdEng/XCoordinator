//
//  File.swift
//  
//
//  Created by Paul Kraft on 09.05.23.
//

import UIKit

public struct SetTabs<RootViewController> {

    // MARK: Stored Properties

    private let animation: Animation?
    private let presentables: () -> [any Presentable]

    // MARK: Initialization

    public init(animation: Animation? = nil, presentables: @escaping () -> [any Presentable]) {
        self.animation = animation
        self.presentables = presentables
    }

}

extension SetTabs: TransitionComponent where RootViewController: UITabBarController {

    public func build() -> Transition<RootViewController> {
        let presentables = presentables()
        return Transition(presentables: presentables, animationInUse: nil) { rootViewController, options, completion in
            if let animation {
                presentables.first?.viewController.transitioningDelegate = animation
            }
            assert(animation == nil || rootViewController.animationDelegate != nil, """
            Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
            This assertion might fail, if the rootViewController specified in the TabBarCoordinator's
            initializer already had a delegate when initializing the TabBarCoordinator.
            To set another delegate of a rootViewController in a TabBarCoordinator, have a look at `TabBarCoordinator.delegate`.
            """)

            CATransaction.begin()
            CATransaction.setCompletionBlock {
                presentables.forEach { $0.presented(from: rootViewController) }
                completion?()
            }

            autoreleasepool {
                rootViewController.setViewControllers(presentables.map(\.viewController), animated: options.animated)
            }

            CATransaction.commit()
        }
    }

}
