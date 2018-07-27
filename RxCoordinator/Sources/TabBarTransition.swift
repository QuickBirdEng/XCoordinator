//
//  TabBarTransition.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

public struct TabBarTransition: Transition {
    private let type: TabBarTransitionType

    private init(type: TabBarTransitionType) {
        self.type = type
    }

    internal init(type: TabBarTransitionType, animation: Animation?) {
        guard let animation = animation else {
            self.init(type: type)
            return
        }
        self.init(type: .animated(type, animation: animation))
    }
    public static func generateRootViewController() -> UITabBarController {
        return UITabBarController()
    }

    public var presentable: Presentable? {
        return type.presentable
    }

    public func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where TabBarTransition == C.TransitionType {
        return type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}
