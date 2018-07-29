//
//  SplitCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

import Foundation

open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, SplitViewTransition> {

    // MARK: - Init

    public init(master: Presentable, detail: Presentable) {
        super.init(initialTransition: .show(master)) { `self` in
            self.performTransition(.showDetail(detail), with: TransitionOptions(animated: false))
        }
    }
}
