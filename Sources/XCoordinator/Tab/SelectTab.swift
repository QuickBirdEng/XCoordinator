//
//  File.swift
//  
//
//  Created by Paul Kraft on 09.05.23.
//

import UIKit

public struct SelectTab<RootViewController> {

    // MARK: Stored Properties

    private let index: Int?
    private let presentable: (() -> any Presentable)?
    private let animation: Animation?

    // MARK: Initialization

    public init(at index: Int, animation: Animation? = nil) {
        self.index = index
        self.animation = animation
        self.presentable = nil
    }

    public init(animation: Animation? = nil, presentable: @escaping () -> any Presentable) {
        self.animation = animation
        self.presentable = presentable
        self.index = nil
    }

}

extension SelectTab: TransitionComponent where RootViewController: UITabBarController {

    public func build() -> Transition<RootViewController> {
        if let index {
            return Transition(
                presentables: [],
                animationInUse: animation?.presentationAnimation
            ) { rootViewController, options, completion in
                if let animation {
                    rootViewController.viewControllers?[index].transitioningDelegate = animation
                }
                assert(animation == nil || rootViewController.animationDelegate != nil, """
                Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
                This assertion might fail, if the rootViewController specified in the TabBarCoordinator's
                initializer already had a delegate when initializing the TabBarCoordinator.
                To set another delegate of a rootViewController in a TabBarCoordinator, have a look at `TabBarCoordinator.delegate`.
                """)

                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)

                autoreleasepool {
                    rootViewController.selectedIndex = index
                }

                CATransaction.commit()
            }
        } else if let presentable = presentable?() {
            return Transition(
                presentables: [presentable],
                animationInUse: animation?.presentationAnimation
            ) { rootViewController, options, completion in
                if let animation {
                    presentable.viewController.transitioningDelegate = animation
                }
                assert(animation == nil || rootViewController.animationDelegate != nil, """
                Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
                This assertion might fail, if the rootViewController specified in the TabBarCoordinator's
                initializer already had a delegate when initializing the TabBarCoordinator.
                To set another delegate of a rootViewController in a TabBarCoordinator, have a look at `TabBarCoordinator.delegate`.
                """)

                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)

                autoreleasepool {
                    rootViewController.selectedViewController = presentable.viewController
                }

                CATransaction.commit()
            }
        } else {
            return .none()
        }
    }

}
