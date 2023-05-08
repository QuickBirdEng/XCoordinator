//
//  Transition+Init.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension Transition {

    ///
    /// Shows a viewController by calling `show` on the rootViewController.
    ///
    /// - Note:
    ///     Prefer `Transition.push` when using transitions on a `UINavigationController` rootViewController.
    ///     In contrast to this transition, you can specify an animation.
    ///
    /// - Parameter presentable:
    ///     The presentable to be shown as a primary view controller.
    ///
    public static func show(_ presentable: any Presentable) -> Transition {
        Transition {
            Show {
                presentable
            }
        }
    }

    ///
    /// Shows a detail viewController by calling `showDetail` on the rootViewController.
    ///
    /// - Note:
    ///     Prefer `Transition.push` when using transitions on a `UINavigationController` rootViewController.
    ///     In contrast to this transition, you can specify an animation.
    ///
    /// - Parameter presentable:
    ///     The presentable to be shown as a detail view controller.
    ///
    public static func showDetail(_ presentable: any Presentable) -> Transition {
        Transition {
            ShowDetail {
                presentable
            }
        }
    }

    ///
    /// Transition to present the given presentable on the rootViewController.
    ///
    /// The present-transition might also be helpful as it always presents on top of what is currently
    /// presented.
    ///
    /// - Parameters:
    ///     - presentable: The presentable to be presented.
    ///     - animation:
    ///         The animation to be set as the presentable's transitioningDelegate. Specify `nil` to not override
    ///         the current transitioningDelegate and `Animation.default` to reset the transitioningDelegate to use
    ///         the default UIKit animations.
    ///
    public static func presentOnRoot(_ presentable: any Presentable, animation: Animation? = nil) -> Transition {
        Transition {
            Present(onRoot: true, animation: animation) {
                presentable
            }
        }
    }

    ///
    /// Transition to present the given presentable. It uses the rootViewController's presentedViewController,
    /// if present, otherwise it is equivalent to `presentOnRoot`.
    ///
    /// - Parameters:
    ///     - presentable: The presentable to be presented.
    ///     - animation:
    ///         The animation to be set as the presentable's transitioningDelegate. Specify `nil` to not override
    ///         the current transitioningDelegate and `Animation.default` to reset the transitioningDelegate to use
    ///         the default UIKit animations.
    ///
    public static func present(_ presentable: any Presentable, animation: Animation? = nil) -> Transition {
        Transition {
            Present(animation: animation) {
                presentable
            }
        }
    }

    ///
    /// Transition to embed the given presentable in a specific container (i.e. a view or viewController).
    ///
    /// - Parameters:
    ///     - presentable: The presentable to be embedded.
    ///     - container: The container to embed the presentable in.
    ///
    public static func embed(_ presentable: any Presentable, in container: any Container) -> Transition {
        Transition {
            Embed(in: container) {
                presentable
            }
        }
    }

    ///
    /// Transition to call dismiss on the rootViewController. Also take a look at the `dismiss` transition,
    /// which calls dismiss on the rootViewController's presentedViewController, if present.
    ///
    /// - Parameter animation:
    ///     The animation to be used by the rootViewController's presentedViewController.
    ///     Specify `nil` to not override its transitioningDelegate or `Animation.default` to fall back to the
    ///     default UIKit animations.
    ///
    public static func dismissToRoot(animation: Animation? = nil) -> Transition {
        Transition {
            Dismiss(toRoot: true, animation: animation)
        }
    }

    ///
    /// Transition to call dismiss on the rootViewController's presentedViewController, if present.
    /// Otherwise, it is equivalent to `dismissToRoot`.
    ///
    /// - Parameter animation:
    ///     The animation to be used by the rootViewController's presentedViewController.
    ///     Specify `nil` to not override its transitioningDelegate or `Animation.default` to fall back to the
    ///     default UIKit animations.
    ///
    public static func dismiss(animation: Animation? = nil) -> Transition {
        Transition {
            Dismiss(animation: animation)
        }
    }

    ///
    /// No transition at all. May be useful for testing or debugging purposes, or to ignore specific
    /// routes.
    ///
    public static func none() -> Transition {
        Transition {}
    }

    ///
    /// With this transition you can chain multiple transitions of the same type together.
    ///
    /// - Parameter transitions:
    ///     The transitions to be chained to form the new transition.
    ///
    public static func multiple<C: Collection>(_ transitions: C) -> Transition where C.Element == Transition {
        Transition(presentables: transitions.flatMap { $0.presentables },
                   animationInUse: transitions.compactMap { $0.animation }.last
        ) { rootViewController, options, completion in
            guard let firstTransition = transitions.first else {
                completion?()
                return
            }
            firstTransition.perform(on: rootViewController, with: options) {
                let newTransitions = Array(transitions.dropFirst())
                Transition
                    .multiple(newTransitions)
                    .perform(on: rootViewController, with: options, completion: completion)
            }
        }
    }

    ///
    /// Use this transition to trigger a route on another coordinator. TransitionOptions and
    /// PresentationHandler used during the execution of this transitions are forwarded.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered on the coordinator.
    ///     - coordinator: The coordinator to trigger the route on.
    ///
    public static func route<C: Coordinator>(_ route: C.RouteType, on coordinator: C) -> Transition {
        Transition {
            Redirect(as: route, to: coordinator)
        }
    }

    ///
    /// Use this transition to trigger a route on another router. TransitionOptions and
    /// PresentationHandler used during the execution of this transitions are forwarded.
    ///
    /// Peeking is not supported with this transition. If needed, use the `route` transition instead.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered on the coordinator.
    ///     - router: The router to trigger the route on.
    ///
    public static func trigger<RouteType: Route>(_ route: RouteType, on router: any Router<RouteType>) -> Transition {
        Transition {
            Trigger(route, on: router)
        }
    }

    ///
    /// Performs a transition on a different viewController than the coordinator's rootViewController.
    ///
    /// This might be helpful when creating a coordinator for a specific viewController would create unnecessary complicated code.
    ///
    /// - Parameters:
    ///     - transition: The transition to be performed.
    ///     - viewController: The viewController to perform the transition on.
    ///
    public static func perform<TransitionType: TransitionProtocol>(_ transition: TransitionType,
                                                                   on viewController: TransitionType.RootViewController) -> Transition {
        Transition(presentables: transition.presentables, animationInUse: transition.animation) { _, options, completion in
            transition.perform(on: viewController, with: options, completion: completion)
        }
    }

}
