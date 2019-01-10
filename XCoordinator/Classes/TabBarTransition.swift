//
//  TabBarTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias TabBarTransition = Transition<UITabBarController>

extension Transition where RootViewController: UITabBarController {
    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> Transition {
        return Transition(presentables: presentables,
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.set(presentables.map { $0.viewController },
                          with: options,
                          animation: animation,
                          completion: {
                            presentables.forEach { $0.presented(from: performer) }
                            completion?()
            })
        }
    }

    public static func select(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(presentables: [presentable],
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.select(presentable.viewController,
                             with: options,
                             animation: animation,
                             completion: completion)
        }
    }

    public static func select(index: Int, animation: Animation? = nil) -> Transition {
        return Transition(presentables: [],
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.select(index: index,
                             with: options,
                             animation: animation,
                             completion: completion)
        }
    }
}
