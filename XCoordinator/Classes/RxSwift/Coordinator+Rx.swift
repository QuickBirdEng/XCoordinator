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

    // swiftlint:disable:next identifier_name
    public var rx: Reactive<Self> {
        return Reactive(self)
    }
}

extension Reactive where Base: Router & AnyObject {
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

    public func trigger(_ route: Base.RouteType) -> Observable<Void> {
        return trigger(route, with: .default)
    }
}

#endif
