//
//  Transition+Init.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension Transition {
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

    public static func none() -> Transition {
        return Transition(presentables: [], animation: nil) { _, _, completion in
            completion?()
        }
    }

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

    public static func route<C: Coordinator>(_ route: C.RouteType, on coordinator: C) -> Transition {
        let transition = coordinator.prepareTransition(for: route)
        return Transition(presentables: transition.presentables,
                          animation: transition.animation
        ) { options, _, completion in
            coordinator.performTransition(transition, with: options, completion: completion)
        }
    }

    /// Peeking is not supported with Transition.trigger. If needed, use Transition.route instead.
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
