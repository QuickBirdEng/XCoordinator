//
//  Coordinator+Rx.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 25.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import RxSwift

public extension Router {
    public var rx: Reactive<Self> {
        return Reactive(self)
    }
}

extension Reactive where Base: Router {
    public func trigger(_ route: Base.RouteType, with options: TransitionOptions) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            self.base.trigger(route, with: options) {
                observer.onNext(())
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    // MARK: - Convenience methods

    public func trigger(_ route: Base.RouteType) -> Observable<Void> {
        return trigger(route, with: .default)
    }
}
