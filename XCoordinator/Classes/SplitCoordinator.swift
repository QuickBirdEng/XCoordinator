//
//  SplitCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, SplitTransition> {

    // MARK: - Init

    public init(master: Presentable, detail: Presentable?) {
        super.init(initialTransition: .set([master, detail].compactMap { $0 }))
    }
}
