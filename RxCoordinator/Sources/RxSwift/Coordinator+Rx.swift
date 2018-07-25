//
//  Coordinator+Rx.swift
//  Action
//
//  Created by Stefan Kofler on 25.07.18.
//

import RxSwift

public extension Coordinator {

    public var rx: Reactive<Self> {
        return Reactive(self)
    }

}

extension Reactive where Base: Coordinator {

    public func trigger(_ route: Base.CoordinatorRoute, with options: TransitionOptions) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            self.base.trigger(route, with: options) {
                observer.onNext(())
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    // MARK: Convenience methods

    public func trigger(_ route: Base.CoordinatorRoute) -> Observable<Void> {
        return trigger(route, with: TransitionOptions.defaultOptions)
    }

}
