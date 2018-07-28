//
//  AnyCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 28.07.18.
//

import Foundation

public class AnyCoordinator<RouteType: Route>: RouteTrigger {
    private let _trigger: (RouteType, TransitionOptions, PresentationHandler?) -> Void
    private let _presented: (Presentable?) -> Void

    public init<C: Coordinator>(_ coordinator: C) where C.RouteType == RouteType {
        _trigger = coordinator.trigger
        _presented = coordinator.presented
    }

    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        _trigger(route, options, completion)
    }

    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }
}
