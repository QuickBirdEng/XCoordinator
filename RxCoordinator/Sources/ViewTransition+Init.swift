//
//  ViewTransition+Init.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

extension ViewTransition {
    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> ViewTransition {
        return ViewTransition(type: .present(presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> ViewTransition {
        return ViewTransition(type: .embed(presentable, in: container), animation: nil)
    }

    public static func registerPeek<C: Coordinator>(from source: Container, route: C.RouteType, coordinator: C) -> ViewTransition where C.TransitionType == ViewTransition {
        return ViewTransition(type: .registerPeek(container: source, transitionGenerator: {
            coordinator.prepareTransition(for: route)
        }), animation: nil)
    }

    public static func dismiss(animation: Animation? = nil) -> ViewTransition {
        return ViewTransition(type: .dismiss, animation: animation)
    }

    public static func none() -> ViewTransition {
        return ViewTransition(type: .none, animation: nil)
    }
}
