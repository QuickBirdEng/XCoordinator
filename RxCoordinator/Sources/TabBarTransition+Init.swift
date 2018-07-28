//
//  TabBarTransition+Init.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

extension TabBarTransition {
    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(type: .set(presentables: presentables), animation: animation)
    }

    public static func select(_ presentable: Presentable, animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(type: .select(presentable: presentable), animation: animation)
    }

    public static func select(index: Int, animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(type: .selectIndex(index), animation: animation)
    }

    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(type: .present(presentable: presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> TabBarTransition {
        return TabBarTransition(type: .embed(presentable: presentable, container: container), animation: nil)
    }

    public static func dismiss(animation: Animation?) -> TabBarTransition {
        return TabBarTransition(type: .dismiss, animation: animation)
    }

    public static func none() -> TabBarTransition {
        return TabBarTransition(type: .none, animation: nil)
    }
}
