//
//  File.swift
//  
//
//  Created by Paul Kraft on 09.05.23.
//

import UIKit


public struct PageSetInitial<RootViewController> {

    // MARK: Stored Properties

    private let presentables: () -> [any Presentable]

    // MARK: Initialization

    public init(_ presentables: @escaping () -> [any Presentable]) {
        self.presentables = presentables
    }

}

extension PageSetInitial: TransitionComponent where RootViewController: UIPageViewController {

    public func build() -> Transition<RootViewController> {
        let pages = presentables()
        return Transition(presentables: pages, animationInUse: nil) { rootViewController, _, completion in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                pages.forEach { $0.presented(from: rootViewController) }
                completion?()
            }
            CATransaction.commit()
        }
    }

}
