//
//  Coordinator+RxCocoa.swift
//  XCoordinator
//
//  Created by Dmitry Kuznetsov on 22/04/2019.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(RxSwift) && canImport(RxCocoa)
import RxCocoa
import RxSwift

extension Reactive where Base: Router & AnyObject {

    /// Bindable sink for trigger(_ route:) method.
    var trigger: Binder<Base.RouteType> {
        return Binder(base) { $0.trigger($1) }
    }

}

#endif
