//
//  Router+Rx.swift
//  XCoordinatorRx
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(XCoordinator) && canImport(RxSwift)

import RxSwift
import XCoordinator

///
/// A namespace for RxSwift observables exposed by a `Router`.
///
/// Routers expose this namespace via ``Router/rx``, mirroring the `Router.publishers` Combine namespace.
/// Use the methods on this type — `trigger(_:with:)` and `contextTrigger(_:with:)` — to obtain
/// observables that emit when transitions complete.
///
@MainActor
public struct ReactiveRouter<RouteType: Route> {

    // MARK: Stored Properties

    fileprivate let base: any Router<RouteType>

    // MARK: Initialization

    fileprivate init(_ base: any Router<RouteType>) {
        self.base = base
    }

}

extension Router {

    /// Use this to access the reactive extensions of `Router` objects.
    public var rx: ReactiveRouter<RouteType> {
        // swiftlint:disable:previous identifier_name
        ReactiveRouter(self)
    }

}

extension ReactiveRouter {

    // MARK: Convenience methods

    ///
    /// Wraps a route trigger in an `Observable<Void>` that emits once the transition has completed.
    ///
    /// - Parameters:
    ///   - route: The route to trigger.
    ///   - options: Transition options. Defaults to animated.
    /// - Returns: An observable emitting `()` and then completing when the transition finishes.
    ///
    public func trigger(_ route: RouteType, with options: TransitionOptions = .init(animated: true)) -> Observable<Void> {
        Observable.create { [base] observer -> Disposable in
            base.trigger(route, with: options) {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    ///
    /// Wraps a route trigger in an `Observable<any TransitionContext>` that emits the resulting
    /// transition context once the transition has completed.
    ///
    /// Useful for deep linking when the resulting context is required for further processing.
    ///
    /// - Parameters:
    ///   - route: The route to trigger.
    ///   - options: Transition options. Defaults to animated.
    /// - Returns: An observable emitting the transition context and then completing.
    ///
    public func contextTrigger(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Observable<any TransitionContext> {
        Observable.create { [base] observer -> Disposable in
            base.contextTrigger(route, with: options) {
                observer.onNext($0)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}

#endif
