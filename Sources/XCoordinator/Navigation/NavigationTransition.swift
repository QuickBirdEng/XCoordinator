//
//  NavigationTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

/// NavigationTransition offers transitions that can be used
/// with a `UINavigationController` as rootViewController.
public typealias NavigationTransition = Transition<UINavigationController>

extension Transition where RootViewController: UINavigationController {

    ///
    /// Pushes a presentable on the rootViewController's navigation stack.
    ///
    /// - Parameters:
    ///     - presentable: The presentable to be pushed onto the navigation stack.
    ///     - animation:
    ///         The animation to set for the presentable. Its presentationAnimation will be used for the
    ///         immediate push-transition, its dismissalAnimation is used for the pop-transition,
    ///         if not otherwise specified. Specify `nil` here to leave animations as they were set for the
    ///         presentable before. You can use `Animation.default` to reset the previously set animations
    ///         on this presentable.
    ///
    public static func push(_ presentable: any Presentable, animation: Animation? = nil) -> Transition {
        Transition {
            Push(animation: animation) {
                presentable
            }
        }
    }

    ///
    /// Pops the topViewController from the rootViewController's navigation stack.
    ///
    /// - Parameter animation:
    ///     The animation to set for the presentable. Only its dismissalAnimation is used for the
    ///     pop-transition. Specify `nil` here to leave animations as they were set for the
    ///     presentable before. You can use `Animation.default` to reset the previously set animations
    ///     on this presentable.
    ///
    public static func pop(animation: Animation? = nil) -> Transition {
        Transition {
            Pop(animation: animation)
        }
    }

    ///
    /// Pops viewControllers from the rootViewController's navigation stack until the specified
    /// presentable is reached.
    ///
    /// - Parameters:
    ///     - presentable:
    ///         The presentable to pop to. Make sure this presentable is in the rootViewController's
    ///         navigation stack before performing such a transition.
    ///     - animation:
    ///         The animation to set for the presentable. Only its dismissalAnimation is used for the
    ///         pop-transition. Specify `nil` here to leave animations as they were set for the
    ///         presentable before. You can use `Animation.default` to reset the previously set animations
    ///         on this presentable.
    ///
    public static func pop(to presentable: any Presentable, animation: Animation? = nil) -> Transition {
        Transition {
            Pop(to: presentable, animation: animation)
        }
    }

    ///
    /// Pops viewControllers from the rootViewController's navigation stack until only one viewController
    /// is left.
    ///
    /// - Parameter animation:
    ///     The animation to set for the presentable. Only its dismissalAnimation is used for the
    ///     pop-transition. Specify `nil` here to leave animations as they were set for the
    ///     presentable before. You can use `Animation.default` to reset the previously set animations
    ///     on this presentable.
    ///
    public static func popToRoot(animation: Animation? = nil) -> Transition {
        Transition {
            Pop(toRoot: true, animation: animation)
        }
    }

    ///
    /// Replaces the navigation stack of the rootViewController with the specified presentables.
    ///
    /// - Parameters:
    ///     - presentables: The presentables to make up the navigation stack after the transition is done.
    ///     - animation:
    ///         The animation to set for the presentable. Its presentationAnimation will be used for the
    ///         transition animation of the top-most viewController, its dismissalAnimation is used for
    ///         any pop-transition of the whole navigation stack, if not otherwise specified. Specify `nil`
    ///         here to leave animations as they were set for the presentables before. You can use
    ///         `Animation.default` to reset the previously set animations on all presentables.
    ///
    public static func set(_ presentables: [any Presentable], animation: Animation? = nil) -> Transition {
        Transition {
            SetAll(animation: animation) {
                presentables
            }
        }
    }
}
