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
    public static func show(_ presentable: Presentable) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            rootViewController.show(
                presentable.viewController,
                with: options
            ) {
                presentable.presented(from: rootViewController)
                completion?()
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
    public static func showDetail(_ presentable: Presentable) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            rootViewController.showDetail(
                presentable.viewController,
                with: options
            ) {
                presentable.presented(from: rootViewController)
                completion?()
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
    public static func presentOnRoot(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        Transition(presentables: [presentable],
                   animationInUse: animation?.presentationAnimation
        ) { rootViewController, options, completion in
            rootViewController.present(onRoot: true,
                                       presentable.viewController,
                                       with: options,
                                       animation: animation
            ) {
                presentable.presented(from: rootViewController)
                completion?()
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
    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        Transition(presentables: [presentable],
                   animationInUse: animation?.presentationAnimation
        ) { rootViewController, options, completion in
            rootViewController.present(onRoot: false,
                                       presentable.viewController,
                                       with: options,
                                       animation: animation
            ) {
                presentable.presented(from: rootViewController)
                completion?()
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
    public static func embed(_ presentable: Presentable, in container: Container) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            rootViewController.embed(presentable.viewController,
                                     in: container,
                                     with: options
            ) {
                presentable.presented(from: rootViewController)
                completion?()
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
        Transition(presentables: [],
                   animationInUse: animation?.dismissalAnimation
        ) { rootViewController, options, completion in
            rootViewController.dismiss(toRoot: true,
                                       with: options,
                                       animation: animation,
                                       completion: completion)
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
        Transition(presentables: [],
                   animationInUse: animation?.dismissalAnimation
        ) { rootViewController, options, completion in
            rootViewController.dismiss(toRoot: false,
                                       with: options,
                                       animation: animation,
                                       completion: completion)
        }
    }

    ///
    /// No transition at all. May be useful for testing or debugging purposes, or to ignore specific
    /// routes.
    ///
    public static func none() -> Transition {
        Transition(presentables: [], animationInUse: nil) { _, _, completion in
            completion?()
        }
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
        let transition = coordinator.prepareTransition(for: route)
        return Transition(presentables: transition.presentables,
                          animationInUse: transition.animation
        ) { _, options, completion in
            coordinator.performTransition(transition, with: options, completion: completion)
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
    public static func trigger<R: Router>(_ route: R.RouteType, on router: R) -> Transition {
        Transition(presentables: [], animationInUse: nil) { _, options, completion in
            router.trigger(route, with: options, completion: completion)
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

extension Coordinator where Self: AnyObject {

    ///
    /// Use this transition to register 3D Touch Peek and Pop functionality.
    ///
    /// - Parameters:
    ///     - source: The view to register peek and pop on.
    ///     - route: The route to be triggered for peek and pop.
    ///
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use `UIContextMenuInteraction` instead.")
    public func registerPeek<RootViewController>(for source: Container,
                                                 route: RouteType
        ) -> Transition<RootViewController> where Self.TransitionType == Transition<RootViewController> {
        let transitionGenerator = { [weak self] () -> TransitionType in
            self?.prepareTransition(for: route) ?? .none()
        }
        return Transition(presentables: [], animationInUse: nil) { rootViewController, _, completion in
            rootViewController.registerPeek(from: source.view,
                                            transitionGenerator: transitionGenerator,
                                            completion: completion)
        }
    }

}
