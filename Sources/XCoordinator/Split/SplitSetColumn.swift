//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

@available(iOS 14, *)
public struct SplitSetColumn<RootViewController> {

    // MARK: Stored Properties

    private let presentable: () -> (any Presentable)?
    private let column: UISplitViewController.Column

    // MARK: Initialization

    public init(_ column: UISplitViewController.Column, _ presentable: @escaping () -> (any Presentable)?) {
        self.column = column
        self.presentable = presentable
    }

}

@available(iOS 14, *)
extension SplitSetColumn: TransitionComponent where RootViewController: UISplitViewController {

    public func build() -> Transition<RootViewController> {
        let presentable = presentable()
        return Transition(presentables: [presentable].compactMap { $0 }, animationInUse: nil) { rootViewController, _, completion in
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
