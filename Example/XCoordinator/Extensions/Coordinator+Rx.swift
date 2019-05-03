//
//  Coordinator+Rx.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 15.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(XCoordinator) && canImport(RxSwift)

import RxSwift
import XCoordinator

extension Reactive where Base: Router & AnyObject {
    public func contextTrigger(_ route: Base.RouteType,
                               with options: TransitionOptions) -> Observable<TransitionContext> {
        return Observable.create { [weak base] observer -> Disposable in
            guard let base = base else {
                observer.onCompleted()
                return Disposables.create()
            }
            base.contextTrigger(route, with: options) { context in
                observer.onNext(context)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Convenience methods

    public func contextTrigger(_ route: Base.RouteType) -> Observable<TransitionContext> {
        return contextTrigger(route, with: TransitionOptions(animated: true))
    }
}

#endif
