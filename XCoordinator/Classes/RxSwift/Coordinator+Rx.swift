//
//  Coordinator+Rx.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 25.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(RxSwift)
import RxSwift

extension Router {

    /// The reactive extensions of a `Router`.
    public var rx: Reactive<Self> {
        // swiftlint:disable:previous identifier_name
        return Reactive(self)
    }
}

extension Reactive where Base: Router & AnyObject {

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
    ///     An Observable<Void> to inform about the completion of the transition.
    ///
    public func trigger(_ route: Base.RouteType, with options: TransitionOptions) -> Observable<Void> {
        return Observable.create { [weak base] observer -> Disposable in
            guard let base = base else {
                observer.onCompleted()
                return Disposables.create()
            }
            base.trigger(route, with: options) {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Convenience methods

    ///
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// It uses the default transition options as specified in `Router.trigger`.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Returns:
    ///     An Observable<Void> to inform about the completion of the transition.
    ///
    public func trigger(_ route: Base.RouteType) -> Observable<Void> {
        return trigger(route, with: .default)
    }
}

#endif
