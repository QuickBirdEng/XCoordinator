//
//  Transition+Init.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension Transition {

    // TODO: Add documentation
    public static func show(_ presentable: Presentable) -> Transition {
        return Transition(presentables: [presentable],
                          animation: nil
        ) { options, performer, completion in
            performer.show(
                presentable.viewController,
                with: options
            ) {
                presentable.presented(from: performer)
                completion?()
            }
        }
    }

    // TODO: Add documentation
    public static func showDetail(_ presentable: Presentable) -> Transition {
        return Transition(presentables: [presentable],
                          animation: nil
        ) { options, performer, completion in
            performer.showDetail(
                presentable.viewController,
                with: options
            ) {
                presentable.presented(from: performer)
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
    /// - Parameter presentable:
    ///     The presentable to be presented.
    ///
    /// - Parameter animation:
    ///     The animation to be set as the presentable's transitioningDelegate. Specify `nil` to not override
    ///     the current transitioningDelegate and `Animation.default` to reset the transitioningDelegate to use
    ///     the default UIKit animations.
    ///
    public static func presentOnRoot(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(presentables: [presentable],
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.present(onRoot: true,
                              presentable.viewController,
                              with: options,
                              animation: animation
            ) {
                presentable.presented(from: performer)
                completion?()
            }
        }
    }

    ///
    /// Transition to present the given presentable. It uses the rootViewController's presentedViewController,
    /// if present, otherwise it is equivalent to `presentOnRoot`.
    ///
    /// - Parameter presentable:
    ///     The presentable to be presented.
    ///
    /// - Parameter animation:
    ///     The animation to be set as the presentable's transitioningDelegate. Specify `nil` to not override
    ///     the current transitioningDelegate and `Animation.default` to reset the transitioningDelegate to use
    ///     the default UIKit animations.
    ///
    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(presentables: [presentable],
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.present(onRoot: false,
                              presentable.viewController,
                              with: options,
                              animation: animation
            ) {
                presentable.presented(from: performer)
                completion?()
            }
        }
    }

    ///
    /// Transition to embed the given presentable in a specific container (i.e. a view or viewController).
    ///
    /// - Parameter presentable:
    ///     The presentable to be embedded.
    ///
    /// - Parameter container:
    ///     The container to embed the presentable in.
    ///
    public static func embed(_ presentable: Presentable, in container: Container) -> Transition {
        return Transition(presentables: [presentable], animation: nil) { options, performer, completion in
            performer.embed(presentable.viewController,
                            in: container,
                            with: options
            ) {
                presentable.presented(from: performer)
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
        return Transition(presentables: [],
                          animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.dismiss(toRoot: true,
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
        return Transition(presentables: [],
                          animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.dismiss(toRoot: false,
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
        return Transition(presentables: [], animation: nil) { _, _, completion in
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
        return Transition(presentables: transitions.flatMap { $0.presentables },
                          animation: transitions.compactMap { $0.animation }.last
        ) { options, performer, completion in
            guard let firstTransition = transitions.first else {
                completion?()
                return
            }
            firstTransition.perform(options: options, performer: performer) {
                let newTransitions = Array(transitions.dropFirst())
                performer.performTransition(.multiple(newTransitions),
                                            with: options,
                                            completion: completion)
            }
        }
    }

    ///
    /// Use this transition to trigger a route on another coordinator. TransitionOptions and
    /// PresentationHandler used during the execution of this transitions are forwarded.
    ///
    /// - Parameter route:
    ///     The route to be triggered on the coordinator.
    ///
    /// - Parameter coordinator:
    ///     The coordinator to trigger the route on.
    ///
    public static func route<C: Coordinator>(_ route: C.RouteType, on coordinator: C) -> Transition {
        let transition = coordinator.prepareTransition(for: route)
        return Transition(presentables: transition.presentables,
                          animation: transition.animation
        ) { options, _, completion in
            coordinator.performTransition(transition, with: options, completion: completion)
        }
    }

    ///
    /// Use this transition to trigger a route on another router. TransitionOptions and
    /// PresentationHandler used during the execution of this transitions are forwarded.
    ///
    /// Peeking is not supported with this transition. If needed, use the `route` transition instead.
    ///
    /// - Parameter route:
    ///     The route to be triggered on the coordinator.
    ///
    /// - Parameter router:
    ///     The router to trigger the route on.
    ///
    public static func trigger<R: Router>(_ route: R.RouteType, on router: R) -> Transition {
        return Transition(presentables: [], animation: nil) { options, _, completion in
            router.trigger(route, with: options, completion: completion)
        }
    }

    @available(iOS, introduced: 9.0, deprecated, message: "Use Coordinator.registerPeek instead.")
    public static func registerPeek(for source: Container,
                                    transition: @escaping () -> Transition) -> Transition {
        return Transition(presentables: [], animation: nil) { _, performer, completion in
            performer.registerPeek(from: source.view,
                                   transitionGenerator: transition,
                                   completion: completion)
        }
    }

    @available(iOS, introduced: 9.0, deprecated, message: "Use Coordinator.registerPeek instead.")
    public static func registerPeek<C: Coordinator & AnyObject>(for source: Container,
                                                                route: C.RouteType,
                                                                coordinator: C) -> Transition where C.TransitionType == Transition {
        return .registerPeek(for: source, transition: { [weak coordinator] in coordinator?.prepareTransition(for: route) ?? .none() })
    }
}

extension Coordinator where Self: AnyObject {

    ///
    /// Use this transition to register 3D Touch Peek and Pop functionality.
    ///
    /// - Parameter source:
    ///     The view to register peek and pop on.
    ///
    /// - Parameter route:
    ///     The route to be triggered for peek and pop.
    ///
    @available(iOS 9.0, *)
    public func registerPeek<RootViewController>(for source: Container,
                                                 route: RouteType
        ) -> Transition<RootViewController> where Self.TransitionType == Transition<RootViewController> {
            return Transition(presentables: [], animation: nil) { [weak self] _, performer, completion in
                performer.registerPeek(from: source.view,
                                       transitionGenerator: { self?.prepareTransition(for: route) ?? .none() },
                                       completion: completion)
            }
    }
}
