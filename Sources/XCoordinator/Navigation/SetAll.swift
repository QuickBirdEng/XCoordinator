//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct SetAll<RootViewController> {

    // MARK: Stored Properties

    private let presentables: () -> [any Presentable]
    private let animation: Animation?

    // MARK: Initialization

    public init(animation: Animation? = nil, presentables: @escaping () -> [any Presentable]) {
        self.animation = animation
        self.presentables = presentables
    }

}

extension SetAll: TransitionComponent where RootViewController: UINavigationController {

    public func build() -> Transition<RootViewController> {
        let presentables = presentables()

        return Transition(presentables: presentables,
                          animationInUse: animation?.presentationAnimation
        ) { rootViewController, options, completion in
            if let animation {
                presentables.last?.viewController?.transitioningDelegate = animation
            }
            assert(animation == nil || rootViewController.animationDelegate != nil, """
            Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
            This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
            initializer already had a delegate when initializing the NavigationCoordinator.
            To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
            """)

            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if let animation = animation {
                    presentables.forEach { $0.viewController?.transitioningDelegate = animation }
                }
                presentables.forEach { $0.presented(from: rootViewController) }
                completion?()
            }

            autoreleasepool {
                rootViewController.setViewControllers(presentables.map { $0.viewController }, animated: options.animated)
            }

            CATransaction.commit()
        }
    }

}
