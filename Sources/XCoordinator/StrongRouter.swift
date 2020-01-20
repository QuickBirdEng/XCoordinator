//
//  StrongRouter.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// StrongRouter is a type-erasure of a given Router object and, therefore, can be used as an abstraction from a specific Router
/// implementation without losing type information about its RouteType.
///
/// StrongRouter abstracts away any implementation specific details and
/// essentially reduces them to properties specified in the `Router` protocol.
///
/// - Note:
///     Do not hold a reference to any router from the view hierarchy.
///     Use `UnownedRouter` or `WeakRouter` in your view controllers or view models instead.
///     You can create them using the `Coordinator.unownedRouter` and `Coordinator.weakRouter` properties.
///
public final class StrongRouter<RouteType: Route>: Router {

    // MARK: Stored properties

    private let _contextTrigger: (RouteType, TransitionOptions, ContextPresentationHandler?) -> Void
    private let _trigger: (RouteType, TransitionOptions, PresentationHandler?) -> Void
    private let _presented: (Presentable?) -> Void
    private let _viewController: () -> UIViewController?
    private let _setRoot: (UIWindow) -> Void
    private let _registerParent: (Presentable & AnyObject) -> Void
    private let _childTransitionCompleted: () -> Void

    // MARK: Initialization

    ///
    /// Creates a StrongRouter object from a given router.
    ///
    /// - Parameter router:
    ///     The source router.
    ///
    public init<T: Router>(_ router: T) where T.RouteType == RouteType {
        _trigger = router.trigger
        _presented = router.presented
        _viewController = { router.viewController }
        _setRoot = router.setRoot
        _contextTrigger = router.contextTrigger
        _registerParent = router.registerParent
        _childTransitionCompleted = router.childTransitionCompleted
    }

    // MARK: Public methods

    ///
    /// Triggers routes and provides the transition context in the completion-handler.
    ///
    /// Useful for deep linking. It is encouraged to use `trigger` instead, if the context is not needed.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options: Transition options configuring the execution of transitions, e.g. whether it should be animated.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///         If the context is not needed, use `trigger` instead.
    ///
    public func contextTrigger(_ route: RouteType,
                               with options: TransitionOptions,
                               completion: ContextPresentationHandler?) {
        _contextTrigger(route, options, completion)
    }

    ///
    /// Triggers the specified route by performing a transition.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options: Transition options for performing the transition, e.g. whether it should be animated.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        _trigger(route, options, completion)
    }

    ///
    /// This method is called whenever a Presentable is shown to the user.
    /// It further provides information about the presentable responsible for the presenting.
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
        _viewController()
    }

    public func registerParent(_ presentable: Presentable & AnyObject) {
        _registerParent(presentable)
    }

    public func childTransitionCompleted() {
        _childTransitionCompleted()
    }

}
