//
//  Transition+Init.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension Transition {
    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return .init(presentable: presentable) { options, performer, completion in
            presentable.presented(from: performer)
            performer.present(
                presentable.viewController,
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> Transition {
        return .init(presentable: presentable) { options, performer, completion in
            presentable.presented(from: performer)
            performer.embed(
                presentable.viewController,
                in: container,
                with: options,
                completion: completion
            )
        }
    }

    public static func dismiss(animation: Animation? = nil) -> Transition {
        return .init(presentable: nil) { options, performer, completion in
            performer.dismiss(
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }

    public static func none() -> Transition {
        return .init(presentable: nil) { options, performer, completion in
            completion?()
        }
    }

    public static func multiple<C: Collection>(_ transitions: C) -> Transition where C.Element == Transition {
        return .init(presentable: nil) { options, performer, completion in
            guard let firstTransition = transitions.first else {
                completion?()
                return
            }
            firstTransition.perform(options: options, performer: performer) {
                let newTransitions = Array(transitions.dropFirst())
                performer.performTransition(
                    .multiple(newTransitions),
                    with: options,
                    completion: completion
                )
            }
        }
    }

    public static func registerPeek(for source: Container, transition: @escaping @autoclosure () -> Transition) -> Transition {
        return .init(presentable: nil) { options, performer, completion in
            return performer.registerPeek(
                from: source.view,
                transitionGenerator: { transition() },
                completion: completion
            )
        }
    }

    public static func registerPeek<C: Coordinator>(for source: Container, route: C.RouteType, coordinator: C) -> Transition where C.TransitionType == Transition {
        return .registerPeek(for: source, transition: coordinator.prepareTransition(for: route))
    }

    public static func route<C: Coordinator>(_ route: C.RouteType, on coordinator: C) -> Transition {
        let transition = coordinator.prepareTransition(for: route)
        return .init(presentable: transition.presentable) { options, _, completion in
            coordinator.performTransition(transition, with: options, completion: completion)
        }
    }

    /// Peeking is not supported with Transition.trigger. If needed, use Transition.route instead.
    public static func trigger<Trigger: RouteTrigger>(_ route: Trigger.RouteType, on routeTrigger: Trigger) -> Transition {
        return .init(presentable: nil) { options, _, completion in
            routeTrigger.trigger(route, with: options, completion: completion)
        }
    }
}
