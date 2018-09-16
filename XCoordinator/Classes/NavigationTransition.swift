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
        return NavigationTransition(presentable: presentable) { options, performer, completion in
            performer.push(
                presentable.viewController,
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }

    public static func pop(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentable: nil) { options, performer, completion in
            performer.pop(
                toRoot: false,
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }

    public static func popToRoot(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentable: nil) { options, performer, completion in
            performer.pop(
                toRoot: true,
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }

    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentable: presentables.last) { options, performer, completion in
            performer.set(
                presentables.map { $0.viewController },
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }
}
