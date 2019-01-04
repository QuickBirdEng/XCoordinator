//
//  AnyRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// Use AnyRouter to abstract away from
///
public final class AnyRouter<RouteType: Route>: Router {

    // MARK: - Stored properties

    private let _contextTrigger: (RouteType, TransitionOptions, ContextPresentationHandler?) -> Void
    private let _trigger: (RouteType, TransitionOptions, PresentationHandler?) -> Void
    private let _presented: (Presentable?) -> Void
    private let _viewController: () -> UIViewController?
    private let _setRoot: (UIWindow) -> Void

    // MARK: - Initialization

    ///
    /// Creates an AnyRouter object from a given router.
    ///
    /// - Parameter router:
    ///     The router to create the AnyRouter of.
    ///
    public init<T: Router>(_ router: T) where T.RouteType == RouteType {
        _trigger = router.trigger
        _presented = router.presented
        _viewController = { router.viewController }
        _setRoot = router.setRoot
        _contextTrigger = router.contextTrigger
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
