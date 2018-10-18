//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol RouteTrigger {
    associatedtype RouteType: Route

    func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?)
}

extension RouteTrigger {
    
    // MARK: Convenience methods

    public func trigger(_ route: RouteType, completion: PresentationHandler? = nil)  {
        return trigger(route, with: .default, completion: completion)
    }
}

extension RouteTrigger where Self: Presentable {

    // MARK: - Computed properties

    internal var anyCoordinator: AnyCoordinator<RouteType> {
        return AnyCoordinator(trigger: self)
    }
}
