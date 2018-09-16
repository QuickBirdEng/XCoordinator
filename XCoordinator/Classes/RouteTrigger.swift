//
//  RouteTrigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
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
