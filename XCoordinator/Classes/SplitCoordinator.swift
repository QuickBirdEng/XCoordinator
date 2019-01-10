//
//  SplitCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias SplitTransition = Transition<UISplitViewController>

open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, SplitTransition> {

    // MARK: - Init

    public init(master: Presentable, detail: Presentable?) {
        super.init(initialRoute: nil)
        setViewControllers([master, detail].compactMap { $0 })
    }

    // MARK: - Helpers

    private func setViewControllers(_ presentables: [Presentable]) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            presentables.forEach { $0.presented(from: self) }
        }
        rootViewController.viewControllers = presentables.map { $0.viewController }
        CATransaction.commit()
    }
}
