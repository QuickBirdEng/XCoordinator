//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol Router {
    associatedtype RouteType: Route

    func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?)
}

extension Router {
    
    // MARK: Convenience methods

    public func trigger(_ route: RouteType, completion: PresentationHandler? = nil)  {
        return trigger(route, with: .default, completion: completion)
    }
}

extension Router where Self: Presentable {

    // MARK: - Computed properties

    public var anyRouter: AnyRouter<RouteType> {
        return AnyRouter(self)
    }
}
