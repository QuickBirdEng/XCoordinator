//
//  Router+Combine.swift
//  XCoordinatorCombine
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(Combine) && canImport(XCoordinator)

import Combine
import XCoordinator

public struct PublisherExtension<Base> {
    public let base: Base
}

extension Router {

    public var publishers: PublisherExtension<Self> {
        .init(base: self)
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public func triggerPublisher(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<Void, Never> {
        Future { completion in
            self.trigger(route, with: options) {
                completion(.success(()))
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public func contextTriggerPublisher(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<any TransitionProtocol, Never> {
        Future { completion in
            self.contextTrigger(route, with: options) {
                completion(.success($0))
            }
        }
    }

}

@available(iOS 13.0, tvOS 13.0, *)
extension PublisherExtension where Base: Router {

    public func trigger(
        _ route: Base.RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<Void, Never> {
        base.triggerPublisher(route, with: options)
    }

    public func contextTrigger(
        _ route: Base.RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<any TransitionProtocol, Never> {
        base.contextTriggerPublisher(route, with: options)
    }

}

#endif
