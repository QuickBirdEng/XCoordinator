//
//  NavigationTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

public typealias NavigationTransition = Transition<UINavigationController>

extension Transition where RootViewController: UINavigationController {
    public static func push(_ presentable: Presentable, animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentable: presentable) { options, performer, completion in
            performer.push(presentable.viewController, with: options, animation: animation, completion: completion)
        }
    }

    public static func pop(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentable: nil) { options, performer, completion in
            performer.pop(with: options, toRoot: false, animation: animation, completion: completion)
        }
    }

    public static func popToRoot(animation: Animation? = nil) -> NavigationTransition {
        return NavigationTransition(presentable: nil) { options, performer, completion in
            performer.pop(with: options, toRoot: true, animation: animation, completion: completion)
        }
    }
}
