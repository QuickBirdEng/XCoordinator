//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct Push<RootViewController> {

    // MARK: Stored Properties

    private let presentable: () -> any Presentable
    private let animation: Animation?

    // MARK: Initialization

    public init(animation: Animation? = nil, presentable: @escaping () -> any Presentable) {
        self.presentable = presentable
        self.animation = animation
    }

}

extension Push: TransitionComponent where RootViewController: UINavigationController {

    public func build() -> Transition<RootViewController> {
        let presentable = presentable()
        return Transition(presentables: [presentable], animationInUse: animation?.presentationAnimation) { rootViewController, options, completion in
            if let animation = animation {
                presentable.viewController.transitioningDelegate = animation
            }
            assert(animation == nil || rootViewController.animationDelegate != nil, """
            Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
            This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
            initializer already had a delegate when initializing the NavigationCoordinator.
            To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
            """)

            CATransaction.begin()
            CATransaction.setCompletionBlock { [rootViewController] in
                if let transitionCoordinator = rootViewController.transitionCoordinator {
                    transitionCoordinator.animate(alongsideTransition: nil) { _ in
                        completion?()
                    }
                } else {
                    completion?()
                }
            }

            autoreleasepool {
                rootViewController.pushViewController(presentable.viewController, animated: options.animated)
            }

            CATransaction.commit()
        }
    }

}
