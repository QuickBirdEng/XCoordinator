//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct ShowDetail<RootViewController> {

    // MARK: Stored Properties

    private let presentable: () -> any Presentable

    // MARK: Initialization

    public init(_ presentable: @escaping () -> any Presentable) {
        self.presentable = presentable
    }

}

extension ShowDetail: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        let presentable = presentable()
        return Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                presentable.presented(from: rootViewController)
                completion?()
            }

            autoreleasepool {
                rootViewController.showDetailViewController(presentable.viewController, sender: nil)
            }

            CATransaction.commit()
        }

    }

}
