//
//  UISplitViewController+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 10.01.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// SplitTransition offers different transitions common to a `UISplitViewController` rootViewController.
///
public typealias SplitTransition = Transition<UISplitViewController>

extension Transition where RootViewController: UISplitViewController {

    public static func set(_ presentables: [Presentable]) -> Transition {
        Transition(presentables: presentables, animationInUse: nil) { rootViewController, _, completion in
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

    @available(iOS 14, *)
    public static func set(_ presentable: Presentable?, for column: UISplitViewController.Column) -> Transition {
        Transition(presentables: [presentable].compactMap { $0 }, animationInUse: nil) { rootViewController, _, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                presentable?.presented(from: rootViewController)
                completion?()
            }
            autoreleasepool {
                rootViewController.setViewController(presentable?.viewController, for: column)
            }
            CATransaction.commit()
        }
    }

}
