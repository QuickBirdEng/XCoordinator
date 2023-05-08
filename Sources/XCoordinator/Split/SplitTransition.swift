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

    public static func set(_ presentables: [any Presentable]) -> Transition {
        Transition {
            SplitSetAll {
                presentables
            }
        }
    }

    @available(iOS 14, *)
    public static func set(_ presentable: (any Presentable)?, for column: UISplitViewController.Column) -> Transition {
        Transition {
            SplitSetColumn(column) {
                presentable
            }
        }

    }

}



