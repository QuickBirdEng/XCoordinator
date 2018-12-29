//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol Router: Presentable {
    associatedtype RouteType: Route

    func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?)
}

extension Router {

    // MARK: Convenience methods

    public func trigger(_ route: RouteType, with options: TransitionOptions) {
        return trigger(route, with: options, completion: nil)
    }

    public func trigger(_ route: RouteType, completion: PresentationHandler? = nil) {
        return trigger(route, with: .default, completion: completion)
    }

    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        contextTrigger(route, with: options) { _ in completion?() }
    }
}

extension Router where Self: Presentable {

    // MARK: - Computed properties

    public var anyRouter: AnyRouter<RouteType> {
        return AnyRouter(self)
    }

    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return anyRouter as? AnyRouter<R>
    }
}
