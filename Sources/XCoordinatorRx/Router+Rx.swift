//
//  Router+Rx.swift
//  XCoordinatorRx
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(XCoordinator) && canImport(RxSwift)

import XCoordinator
import RxSwift

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
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// It uses the default transition options as specified in `Router.trigger`.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
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
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// It uses the default transition options as specified in `Router.trigger`.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
    ///
    public func contextTrigger(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Observable<any TransitionProtocol> {
        Observable.create { [base] observer -> Disposable in
            base.contextTrigger(route, with: options) {
                observer.onNext($0)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}

#if canImport(SwiftUI)

@available(iOS 13.0, tvOS 13.0, *)
extension RouterContext {

    /// Use this to access the reactive extensions of `RouterContext` objects.
    public var rx: Reactive<RouterContext> {
        // swiftlint:disable:previous identifier_name
        Reactive(self)
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension Reactive where Base == RouterContext {

    // MARK: Convenience methods

    ///
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// It uses the default transition options as specified in `Router.trigger`.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
    ///
    public func trigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Observable<Bool> {
        Observable.create { [base] observer -> Disposable in
            guard let router = base.router(for: RouteType.self) else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            router.trigger(route, with: options) {
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    ///
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// It uses the default transition options as specified in `Router.trigger`.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
    ///
    public func contextTrigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Observable<(any TransitionProtocol)?> {
        Observable.create { [base] observer -> Disposable in
            guard let router = base.router(for: RouteType.self) else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            router.contextTrigger(route, with: options) {
                observer.onNext($0)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}

#endif

#endif
