//
//  NavigationTransition+Init.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

extension NavigationTransition {
    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(type: .present(presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> NavigationTransition {
        return NavigationTransition(type: .embed(presentable: presentable, container: container), animation: nil)
    }

    public static func registerPeek<C: Coordinator>(from source: Container, route: C.RouteType, coordinator: C) -> NavigationTransition where C.TransitionType == NavigationTransition {
        return NavigationTransition(type: .registerPeek(source: source, transitionGenerator: {
            coordinator.prepareTransition(for: route)
        }), animation: nil)
    }

    public static func dismiss(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(type: .dismiss, animation: animation)
    }

    public static func none() -> NavigationTransition {
        return NavigationTransition(type: .none, animation: nil)
    }

    public static func push(_ presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(type: .push(presentable), animation: animation)
    }

    public static func pop(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(type: .pop, animation: animation)
    }

    public static func popToRoot(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(type: .popToRoot, animation: animation)
    }
}
