//
//  ViewTransition.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

public struct ViewTransition: Transition {

    // MARK: - Stored properties

    private let type: ViewTransitionType

    // MARK: - Computed properties

    public var presentable: Presentable? {
        return type.presentable
    }

    // MARK: - Init

    private init(type: ViewTransitionType) {
        self.type = type
    }

    internal init(type: ViewTransitionType, animation: Animation?) {
        guard let animation = animation else {
            self.init(type: type)
            return
        }
        self.init(type: .animated(type, animation: animation))
    }

    // MARK: - Static functions

    public static func generateRootViewController() -> UIViewController {
        return UIViewController()
    }

    // MARK: - Methods

    public func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where ViewTransition == C.TransitionType {
        return type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}
