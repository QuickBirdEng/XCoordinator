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

extension Router {

    ///
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options, e.g. defining whether or not the transition should be animated.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
    ///
    public func rxTrigger(_ route: RouteType, with options: TransitionOptions = .init(animated: true)) -> Observable<Void> {
        Observable.create { [self] observer -> Disposable in
            self.trigger(route, with: options) {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}

/*

extension Router {

    /// Use this to access the reactive extensions of `Router` objects.
    public var rx: Reactive<any Router<RouteType>> {
        // swiftlint:disable:previous identifier_name
        Reactive(router(for: RouteType.self)!)
    }
}

extension Reactive where Base: Router {



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
    public func trigger(_ route: Base.RouteType) -> Observable<Void> {
        trigger(route, with: TransitionOptions(animated: true))
    }
}

 */

#endif
