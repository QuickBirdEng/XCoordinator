//
//  TabBarTransition+Init.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

extension TabBarTransition {
    public static func set(viewControllers: [UIViewController], animation: Animation? = nil) -> TabBarTransition {
        return TabBarTransition(type: .set(viewControllers: viewControllers), animation: animation)
    }
}
