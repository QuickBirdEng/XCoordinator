//
//  TabBarTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//

public typealias TabBarTransition = Transition<UITabBarController>

extension Transition where RootViewController: UITabBarController {
    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(presentable: nil) { options, performer, completion in
            performer.set(presentables.map { $0.viewController }, with: options, animation: animation, completion: completion)
        }
    }

    public static func select(_ presentable: Presentable, animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(presentable: presentable) { options, performer, completion in
            performer.select(presentable.viewController, with: options, animation: animation, completion: completion)
        }
    }

    public static func select(index: Int, animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(presentable: nil) { options, performer, completion in
            performer.select(index: index, with: options, animation: animation, completion: completion)
        }
    }
}
