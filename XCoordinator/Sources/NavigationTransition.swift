//
//  NavigationTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

public struct NavigationTransition: Transition {

    // MARK: - Stored properties

    private let type: NavigationTransitionType

    // MARK: - Computed properties

    public var presentable: Presentable? {
        return type.presentable
    }

    // MARK: - Init

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

    // MARK: - Static functions

    public static func generateRootViewController() -> UINavigationController {
        return UINavigationController()
    }

    // MARK: - Methods

    public func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where NavigationTransition == C.TransitionType {
        return type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}

extension NavigationTransition {
    public static func multiple(_ transitions: [NavigationTransition], completion: PresentationHandler?) -> NavigationTransition {
        return NavigationTransition(type: .multiple(transitions.map { $0.type }), animation: nil)
    }

    static func multiple(_ transitions: [NavigationTransitionType]) -> NavigationTransition {
        return NavigationTransition(type: .multiple(transitions), animation: nil)
    }
}
