//
//  SplitCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

import Foundation

open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, SplitViewTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(master: Presentable, detail: Presentable) {
        super.init(initialRoute: nil)
        performTransition(.show(master), with: TransitionOptions(animated: false))
        performTransition(.showDetail(detail), with: TransitionOptions(animated: false))
    }
}
