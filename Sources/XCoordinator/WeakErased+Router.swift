//
//  WeakErased+Router.swift
//  XCoordinator
//
//  Created by Paul Kraft on 02.09.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// A `WeakRouter` is a weak version of a router object to be used in view controllers or view models.
///
/// - Note:
///     Do not create a `WeakRouter` from a `StrongRouter` since `StrongRouter` is only another wrapper
///     and does not represent the  might instantly.
///     Also keep in mind that once the original router object has been deallocated,
///     calling `trigger` on this wrapper will have no effect.
///
public typealias WeakRouter<RouteType: Route> = WeakErased<StrongRouter<RouteType>>

extension WeakErased: Presentable where Value: Presentable {

    public var viewController: UIViewController! {
        wrappedValue?.viewController
    }

    public func childTransitionCompleted() {
        wrappedValue?.childTransitionCompleted()
    }

    public func registerParent(_ presentable: Presentable & AnyObject) {
        wrappedValue?.registerParent(presentable)
    }

    public func presented(from presentable: Presentable?) {
        wrappedValue?.presented(from: presentable)
    }

    public func setRoot(for window: UIWindow) {
        wrappedValue?.setRoot(for: window)
    }

}

extension WeakErased: Router where Value: Router {

    public func contextTrigger(_ route: Value.RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        wrappedValue?.contextTrigger(route, with: options, completion: completion)
    }

}
