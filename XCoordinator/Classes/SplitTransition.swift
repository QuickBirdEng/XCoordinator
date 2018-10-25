//
//  SplitViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias SplitTransition = Transition<UISplitViewController>

extension Transition where RootViewController: UISplitViewController {
    public static func show(_ presentable: Presentable, animation: Animation? = nil) -> SplitTransition {
        return SplitTransition(presentable: presentable) { options, performer, completion in
            performer.show(
                presentable.viewController,
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }

    public static func showDetail(_ presentable: Presentable, animation: Animation? = nil) -> SplitTransition {
        return SplitTransition(presentable: presentable) { options, performer, completion in
            performer.showDetail(
                presentable.viewController,
                with: options,
                animation: animation,
                completion: completion
            )
        }
    }
}
