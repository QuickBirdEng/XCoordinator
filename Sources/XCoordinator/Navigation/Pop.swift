//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import SwiftUI

public struct Pop<RootViewController> {

    // MARK: Stored Properties

    private let destination: (any Presentable)?
    private let toRoot: Bool
    private let animation: Animation?

    // MARK: Initialization

    public init(toRoot: Bool = false, animation: Animation? = nil) {
        self.destination = nil
        self.toRoot = toRoot
        self.animation = animation
    }

    public init(to destination: any Presentable, animation: Animation? = nil) {
        self.destination = destination
        self.toRoot = false
        self.animation = animation
    }

}

extension Pop: TransitionComponent where RootViewController: UINavigationController {

    public func build() -> Transition<RootViewController> {
        if let destination {
            return Transition(presentables: [], animationInUse: animation?.dismissalAnimation) { rootViewController, options, completion in
                if let animation {
                    rootViewController.topViewController?.transitioningDelegate = animation
                    destination.viewController.transitioningDelegate = animation
                }

                assert(animation == nil || rootViewController.animationDelegate != nil, """
                Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
                This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
                initializer already had a delegate when initializing the NavigationCoordinator.
                To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
                """)

                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)

                autoreleasepool {
                    _ = rootViewController.popToViewController(destination.viewController, animated: options.animated)
                }

                CATransaction.commit()
            }
        } else {
            return Transition(presentables: [], animationInUse: animation?.dismissalAnimation) { rootViewController, options, completion in
                if let animation {
                    rootViewController.topViewController?.transitioningDelegate = animation
                }
                assert(animation == nil || rootViewController.animationDelegate != nil, """
                Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
                This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
                initializer already had a delegate when initializing the NavigationCoordinator.
                To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
                """)

                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)

                autoreleasepool {
                    if toRoot {
                        rootViewController.popToRootViewController(animated: options.animated)
                    } else {
                        rootViewController.popViewController(animated: options.animated)
                    }
                }

                CATransaction.commit()
            }
        }
    }

}
