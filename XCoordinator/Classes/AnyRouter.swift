//
//  AnyRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public final class AnyRouter<RouteType: Route>: Router {

    // MARK: - Stored properties

    private let _contextTrigger: (RouteType, TransitionOptions, ContextPresentationHandler?) -> Void
    private let _trigger: (RouteType, TransitionOptions, PresentationHandler?) -> Void
    private let _presented: (Presentable?) -> Void
    private let _viewController: () -> UIViewController?
    private let _setRoot: (UIWindow) -> Void

    // MARK: - Init

    public init<T: Router & Presentable>(_ trigger: T) where T.RouteType == RouteType {
        _trigger = trigger.trigger
        _presented = trigger.presented
        _viewController = { trigger.viewController }
        _setRoot = trigger.setRoot
        _contextTrigger = trigger.contextTrigger
    }

    // MARK: - Public methods

    public func contextTrigger(_ route: RouteType,
                               with options: TransitionOptions,
                               completion: ContextPresentationHandler?) {
        _contextTrigger(route, options, completion)
    }

    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        _trigger(route, options, completion)
    }

    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }

    public var viewController: UIViewController! {
        return _viewController()
    }
}
