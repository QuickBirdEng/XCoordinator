//
//  NavigationTransition.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

public struct NavigationTransition: Transition {
    private let type: NavigationTransitionType

    public var presentable: Presentable? {
        return type.presentable
    }

    private init(type: NavigationTransitionType) {
        self.type = type
    }

    internal init(type: NavigationTransitionType, animation: Animation?) {
        guard let animation = animation else {
            self.init(type: type)
            return
        }
        self.init(type: .animated(type, animation: animation))
    }

    public static func generateRootViewController() -> UINavigationController {
        return UINavigationController()
    }

    public func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where NavigationTransition == C.TransitionType {
        return type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
    
    public static func registerPeek<R: Route>(for source: Container, route: R, coordinator: AnyCoordinator<R>) -> NavigationTransition where R.TransitionType == NavigationTransition {
        return NavigationTransition(type: .registerPeek(source: source, transitionGenerator: {
            coordinator.prepareTransition(for: route)
        }))
    }
}
