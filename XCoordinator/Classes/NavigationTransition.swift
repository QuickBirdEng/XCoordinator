//
//  NavigationTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias NavigationTransition = Transition<UINavigationController>

extension Transition where RootViewController: UINavigationController {
    public static func push(_ presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [presentable],
                                    animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.push(presentable.viewController,
                           with: options,
                           animation: animation
            ) {
                presentable.presented(from: performer)
                completion?()
            }
        }
    }

    public static func pop(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [],
                                    animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.pop(toRoot: false,
                          with: options,
                          animation: animation,
                          completion: completion)
        }
    }

    public static func pop(to presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [presentable],
                                    animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.pop(to: presentable.viewController,
                          options: options,
                          animation: animation,
                          completion: completion)
        }
    }

    public static func popToRoot(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: [],
                                    animation: animation?.dismissalAnimation
        ) { options, performer, completion in
            performer.pop(toRoot: true,
                          with: options,
                          animation: animation,
                          completion: completion)
        }
    }

    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentables: presentables,
                                    animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.set(presentables.map { $0.viewController },
                          with: options,
                          animation: animation
            ) {
                presentables.forEach { $0.presented(from: performer) }
                completion?()
            }
        }
    }
}
