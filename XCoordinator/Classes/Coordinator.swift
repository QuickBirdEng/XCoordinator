//
//  Coordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias PresentationHandler = () -> Void
public typealias ContextPresentationHandler = (PresentationHandlerContext) -> Void

public protocol Coordinator: Router, TransitionPerformer {

    ///
    /// This method prepares transitions for routes.
    /// It especially decides, which transitions are performed for the triggered routes.
    ///
    /// - Parameter route:
    ///     The triggered route for which a transition is to be prepared.
    ///
    /// - Returns:
    ///     The prepared transition.
    ///
    func prepareTransition(for route: RouteType) -> TransitionType
}

// MARK: - Typealiases

extension Coordinator {
    public typealias RootViewController = TransitionType.RootViewController
}

// MARK: - Presentable

extension Coordinator {
    public var viewController: UIViewController! {
        return rootViewController
    }
}

// MARK: - Default implementations

extension Coordinator {
    public var anyCoordinator: AnyCoordinator<RouteType, TransitionType> {
        return AnyCoordinator(self)
    }

    public func presented(from presentable: Presentable?) {}

    public func contextTrigger(_ route: RouteType,
                               with options: TransitionOptions,
                               completion: ContextPresentationHandler?) {
        let transition = prepareTransition(for: route)
        let context = PresentationHandlerContext(presentables: transition.presentables)
        performTransition(transition, with: options) { completion?(context) }
    }

    public func chain(routes: [RouteType]) -> TransitionType {
        return .multiple(routes.map(prepareTransition))
    }

    public func performTransition(_ transition: TransitionType,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler? = nil) {
        transition.perform(options: options, coordinator: self, completion: completion)
    }
}
