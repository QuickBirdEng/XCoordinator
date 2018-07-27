//
//  ViewTransition.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

public struct ViewTransition: Transition {
    private let type: ViewTransitionType

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

    public var presentable: Presentable? {
        return type.presentable
    }

    public func perform<R: Route>(options: TransitionOptions, coordinator: AnyCoordinator<R>, completion: PresentationHandler?) where R.TransitionType == ViewTransition {
        return type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}
