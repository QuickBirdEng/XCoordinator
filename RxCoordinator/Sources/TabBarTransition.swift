//
//  TabBarTransition.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

public struct TabBarTransition: Transition {

    // MARK: - Stored properties

    private let type: TabBarTransitionType

    // MARK: - Computed properties

    public var presentable: Presentable? {
        return type.presentable
    }

    // MARK: - Init

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

    // MARK: - Static functions

    public static func generateRootViewController() -> UITabBarController {
        return UITabBarController()
    }

    // MARK: - Methods

    public func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where TabBarTransition == C.TransitionType {
        return type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}
