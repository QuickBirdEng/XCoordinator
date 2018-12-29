//
//  NavigationTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias NavigationTransition = Transition<UINavigationController>

extension Transition where RootViewController: UINavigationController {

    ///
    /// Pushes a presentable on the rootViewController's navigation stack.
    ///
    /// - Parameter presentable:
    ///     The presentable to be pushed onto the navigation stack.
    ///
    /// - Parameter animation:
    ///     The animation to set for the presentable. Its presentationAnimation will be used for the
    ///     immediate push-transition, its dismissalAnimation is used for the pop-transition,
    ///     if not otherwise specified. Specify `nil` here to leave animations as they were set for the
    ///     presentable before. You can use `Animation.default` to reset the previously set animations
    ///     on this presentable.
    ///
    public static func push(_ presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [presentable],
                                    animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.push(presentable.viewController,
                           with: options,
                           animation: animation
            ) {
                presentable.presented(from: performer)
                completion?()
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
    public static func pop(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [],
                                    animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.pop(toRoot: false,
                          with: options,
                          animation: animation,
                          completion: completion)
        }
    }

    ///
    /// Pops viewControllers from the rootViewController's navigation stack until the specified
    /// presentable is reached.
    ///
    /// - Parameter presentable:
    ///     The presentable to pop to. Make sure this presentable is in the rootViewController's
    ///     navigation stack before performing such a transition.
    ///
    /// - Parameter animation:
    ///     The animation to set for the presentable. Only its dismissalAnimation is used for the
    ///     pop-transition. Specify `nil` here to leave animations as they were set for the
    ///     presentable before. You can use `Animation.default` to reset the previously set animations
    ///     on this presentable.
    ///
    public static func pop(to presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [presentable],
                                    animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.pop(to: presentable.viewController,
                          options: options,
                          animation: animation,
                          completion: completion)
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
    public static func popToRoot(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [],
                                    animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.pop(toRoot: true,
                          with: options,
                          animation: animation,
                          completion: completion)
        }
    }

    ///
    /// Sets the navigation stack of the rootViewController to the specified presentables.
    ///
    /// - Parameter presentables:
    ///     The presentables to make up the navigation stack after the transition is done.
    ///
    /// - Parameter animation:
    ///     The animation to set for the presentable. Its presentationAnimation will be used for the
    ///     transition animation of the top-most viewController, its dismissalAnimation is used for
    ///     any pop-transition of the whole navigation stack, if not otherwise specified. Specify `nil`
    ///     here to leave animations as they were set for the presentables before. You can use
    ///     `Animation.default` to reset the previously set animations on all presentables.
    ///
    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: presentables,
                                    animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.set(presentables.map { $0.viewController },
                          with: options,
                          animation: animation
            ) {
                presentables.forEach { $0.presented(from: performer) }
                completion?()
            }
        }
    }
}
