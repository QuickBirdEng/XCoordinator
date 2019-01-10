//
//  SplitTransition.swift
//  Action
//
//  Created by Paul Kraft on 10.01.19.
//

public typealias SplitTransition = Transition<UISplitViewController>

extension Transition where RootViewController: UISplitViewController {
    static func set(_ presentables: [Presentable]) -> Transition {
        return Transition(presentables: presentables, animation: nil) { _, performer, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                presentables.forEach { $0.presented(from: performer) }
                completion?()
            }
            performer.rootViewController.viewControllers = presentables.map { $0.viewController }
            CATransaction.commit()
        }
    }
}
