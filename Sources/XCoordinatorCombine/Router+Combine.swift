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

}

@available(iOS 13.0, tvOS 13.0, *)
extension PublisherExtension where Base: Router {

    public func trigger(
        _ route: Base.RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<Void, Never> {
        base.triggerPublisher(route, with: options)
    }

}

#if canImport(SwiftUI)

@available(iOS 13.0, tvOS 13.0, *)
extension RouterContext {

    public var publishers: PublisherExtension<RouterContext> {
        .init(base: self)
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public func triggerPublisher<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<Bool, Never> {
        Future { completion in
            guard let router = self.router(for: route) else {
                return completion(.success(false))
            }
            router.trigger(route, with: options) {
                completion(.success(true))
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public func contextTriggerPublisher<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<(any TransitionProtocol)?, Never> {
        Future { completion in
            guard let router = self.router(for: route) else {
                return completion(.success(nil))
            }
            router.contextTrigger(route, with: options) {
                completion(.success($0))
            }
        }
    }

}

@available(iOS 13.0, tvOS 13.0, *)
extension PublisherExtension where Base == RouterContext {

    public func contextTrigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<(any TransitionProtocol)?, Never> {
        base.contextTriggerPublisher(route, with: options)
    }

    public func trigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> Future<Bool, Never> {
        base.triggerPublisher(route, with: options)
    }

}


#endif

#endif
