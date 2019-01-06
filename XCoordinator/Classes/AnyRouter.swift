//
//  AnyRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// AnyRouter can be used as an abstraction from a specific Router implementation without losing type information about its RouteType.
///
/// This type abstraction can be especially helpful when injecting routers into viewModels.
/// AnyRouter abstracts away any implementation specifics and reduces coordinators to the capabilities of triggering routes.
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

    ///
    /// Triggers routes and returns context in completion-handler.
    ///
    /// Useful for deep linking. It is encouraged to use `trigger` instead, if the context is not needed.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options configuring the execution of transitions, e.g. whether it should be animated.
    ///
    /// - Parameter completion:
    ///     Optional completion handler. If present, it is executed once the transition is completed (including animations).
    ///     If the context is not needed, use `trigger` instead.
    ///
    public func contextTrigger(_ route: RouteType,
                               with options: TransitionOptions,
                               completion: ContextPresentationHandler?) {
        _contextTrigger(route, options, completion)
    }

    ///
    /// Triggers the specified route by performing a transition.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options for performing the transition, e.g. whether it should be animated.
    ///
    /// - Parameter completion:
    ///     Optional completion handler. If present, it is executed once the transition is completed (including animations).
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        _trigger(route, options, completion)
    }

    ///
    /// This method is called whenever a Presentable is shown to the user.
    /// It further provides information about the context a presentable is shown in.
    ///
    /// - Parameter presentable:
    ///     The context in which the presentable is shown.
    ///     This could be a window, another viewController, a coordinator, etc.
    ///     `nil` is specified whenever a context cannot be easily determined.
    ///
    public func presented(from presentable: Presentable?) {
        _presented(presentable)
    }

    ///
    /// The viewController of the Presentable.
    ///
    /// In the case of a `UIViewController`, it returns itself.
    /// A coordinator returns its rootViewController.
    ///
    public var viewController: UIViewController! {
        return _viewController()
    }
}
