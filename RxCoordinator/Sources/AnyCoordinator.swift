//
//  AnyCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 28.07.18.
//

import Foundation

public final class AnyCoordinator<RouteType: Route>: RouteTrigger {

    // MARK: - Stored properties

    private let _trigger: (RouteType, TransitionOptions, PresentationHandler?) -> Void
    private let _presented: (Presentable?) -> Void

    // MARK: - Init

    public init<C: Coordinator>(_ coordinator: C) where C.RouteType == RouteType {
        _trigger = coordinator.trigger
        _presented = coordinator.presented
    }

    // MARK: - Public methods

    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        _trigger(route, options, completion)
    }

    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }
}
