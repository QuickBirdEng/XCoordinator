//
//  UnownedErased+Router.swift
//  XCoordinator
//
//  Created by Paul Kraft on 02.09.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// Please use `StrongRouter`, `WeakRouter` or `UnownedRouter` instead.
///
/// - Note:
///     Use a `StrongRouter`, if you need to hold a router even
///     when it is not in the view hierarchy.
///     Use a `WeakRouter` or `UnownedRouter` when you are accessing
///     any router from the view hierarchy.
///
@available(iOS, deprecated)
public typealias AnyRouter<RouteType: Route> = UnownedRouter<RouteType>

///
/// An `UnownedRouter` is an unowned version of a router object to be used in view controllers or view models.
///
/// - Note:
///     Do not create an `UnownedRouter` from a `StrongRouter` since `StrongRouter` is only another wrapper
///     and does not represent the  might instantly
///
public typealias UnownedRouter<RouteType: Route> = UnownedErased<StrongRouter<RouteType>>

extension UnownedErased: Presentable where Value: Presentable {

    public var viewController: UIViewController! {
        wrappedValue.viewController
    }

    public func childTransitionCompleted() {
        wrappedValue.childTransitionCompleted()
    }

    public func registerParent(_ presentable: Presentable & AnyObject) {
        wrappedValue.registerParent(presentable)
    }

    public func presented(from presentable: Presentable?) {
        wrappedValue.presented(from: presentable)
    }

    public func setRoot(for window: UIWindow) {
        wrappedValue.setRoot(for: window)
    }

}

extension UnownedErased: Router where Value: Router {

    public func contextTrigger(_ route: Value.RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        wrappedValue.contextTrigger(route, with: options, completion: completion)
    }

}
