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

    ///
    /// Replaces the split view controller's `viewControllers` with the given presentables.
    ///
    /// - Parameter presentables: The presentables that become the split controller's columns, in order.
    public static func set(_ presentables: [any Presentable]) -> Transition {
        Transition {
            SplitSetAll {
                presentables
            }
        }
    }

    ///
    /// Sets a single presentable into the given `UISplitViewController.Column` (iOS 14+ triple-column API).
    ///
    /// - Parameters:
    ///   - presentable: The presentable for the column. Pass `nil` to clear the column.
    ///   - column: The column to set.
    @available(iOS 14, *)
    public static func set(_ presentable: (any Presentable)?, for column: UISplitViewController.Column) -> Transition {
        Transition {
            SplitSetColumn(column) {
                presentable
            }
        }

    }

}



