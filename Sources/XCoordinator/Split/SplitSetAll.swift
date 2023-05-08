//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct SplitSetAll<RootViewController> {

    // MARK: Stored Properties

    private let presentables: () -> [any Presentable]

    // MARK: Initialization

    public init(_ presentables: @escaping () -> [any Presentable]) {
        self.presentables = presentables
    }

}

extension SplitSetAll: TransitionComponent where RootViewController: UISplitViewController {

    public func build() -> Transition<RootViewController> {
        let presentables = presentables()
        return Transition(presentables: presentables, animationInUse: nil) { rootViewController, _, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                presentables.forEach { $0.presented(from: rootViewController) }
                completion?()
            }
            autoreleasepool {
                rootViewController.viewControllers = presentables.map { $0.viewController }
            }
            CATransaction.commit()
        }
    }

}
