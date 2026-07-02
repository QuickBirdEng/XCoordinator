//
//  Router+Combine.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

#if canImport(Combine)

import Combine

///
/// A namespace for Combine publishers exposed by a base value.
///
/// Routers expose this namespace via `router.publishers`, mirroring the `router.rx` namespace
/// in `XCoordinatorRx`. Use the methods on this type — `trigger(_:with:)` and
/// `contextTrigger(_:with:)` — to obtain publishers for route triggers.
///
@MainActor
public struct PublisherExtension<Base> {

    /// The underlying value (typically a `Router`) this namespace wraps.
    public let base: Base
}

extension Router {

    /// The Combine namespace for this router.
    ///
    /// Use `router.publishers.trigger(_:)` to obtain a publisher that performs the route's transition
    /// when subscribed to and completes when the transition finishes.
    public var publishers: PublisherExtension<Self> {
        .init(base: self)
    }

    ///
    /// Triggers a route and returns a publisher that completes when the transition finishes.
    ///
    /// The transition is performed on **subscription** (the returned publisher is lazy), so no
    /// navigation happens until a subscriber attaches. Prefer the convenience accessor ``publishers``
    /// for new code: `router.publishers.trigger(.home)`.
    ///
    /// - Parameters:
    ///   - route: The route to trigger.
    ///   - options: Transition options. Defaults to animated.
    /// - Returns: A publisher that emits `()` and finishes once the transition completes.
    ///
    public func triggerPublisher(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> AnyPublisher<Void, Never> {
        Deferred {
            Future { completion in
                self.trigger(route, with: options) {
                    completion(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    ///
    /// Triggers a route and returns a publisher that emits the resulting transition context.
    ///
    /// The transition is performed on **subscription** (the returned publisher is lazy). Useful for
    /// deep linking. Prefer ``publishers`` for new code: `router.publishers.contextTrigger(.home)`.
    ///
    /// - Parameters:
    ///   - route: The route to trigger.
    ///   - options: Transition options. Defaults to animated.
    /// - Returns: A publisher that emits the transition context and finishes.
    ///
    public func contextTriggerPublisher(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> AnyPublisher<any TransitionContext, Never> {
        Deferred {
            Future { completion in
                self.contextTrigger(route, with: options) {
                    completion(.success($0))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}

extension PublisherExtension where Base: Router {

    /// Triggers a route on the wrapped router and returns a publisher that completes when the transition finishes.
    ///
    /// The transition is performed on subscription (lazy).
    ///
    /// - Parameters:
    ///   - route: The route to trigger.
    ///   - options: Transition options. Defaults to animated.
    public func trigger(
        _ route: Base.RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> AnyPublisher<Void, Never> {
        base.triggerPublisher(route, with: options)
    }

    /// Triggers a route on the wrapped router and returns a publisher emitting the resulting transition context.
    ///
    /// The transition is performed on subscription (lazy).
    ///
    /// - Parameters:
    ///   - route: The route to trigger.
    ///   - options: Transition options. Defaults to animated.
    public func contextTrigger(
        _ route: Base.RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) -> AnyPublisher<any TransitionContext, Never> {
        base.contextTriggerPublisher(route, with: options)
    }

}

#endif
