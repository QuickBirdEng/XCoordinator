//
//  TabBarTransitionType.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

internal enum TabBarTransitionType {
    indirect case animated(TabBarTransitionType, animation: Animation)
    case set(viewControllers: [UIViewController])

    var presentable: Presentable? {
        return nil // TODO
    }

    public func perform<C: Coordinator>(options: TransitionOptions, animation: Animation?, coordinator: C, completion: PresentationHandler?) where TabBarTransition == C.TransitionType {
        // TODO
    }
}
