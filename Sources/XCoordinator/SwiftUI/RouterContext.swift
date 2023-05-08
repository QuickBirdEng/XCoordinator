//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import Foundation

@available(iOS 13.0, tvOS 13.0, *)
public class RouterContext: RouterContextReplacable {

    // MARK: Stored Properties

    private weak var presentable: (any Presentable & AnyObject)?

    // MARK: Initialization

    public init() {}

    // MARK: Methods

    public func replaceContext(with router: any Router) {
        self.presentable = router
    }

    public func router<RouteType: Route>(for route: RouteType.Type) -> (any Router<RouteType>)? {
        presentable?.router(for: route)
    }

    @MainActor
    @discardableResult
    public func trigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true),
        completion: PresentationHandler? = nil
    ) -> Bool {
        router(for: RouteType.self)?.trigger(route, with: options, completion: completion) != nil
    }

    @MainActor
    @discardableResult
    public func contextTrigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true),
        completion: ContextPresentationHandler? = nil
    ) -> Bool {
        router(for: RouteType.self)?.contextTrigger(route, with: options, completion: completion) != nil
    }

}

#if swift(>=5.5.2)

@available(iOS 13.0, tvOS 13.0, *)
extension RouterContext {

    @MainActor
    @discardableResult
    public func trigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) async -> Bool {
        await router(for: RouteType.self)?.trigger(route, with: options) != nil
    }

    @MainActor
    @discardableResult
    public func contextTrigger<RouteType: Route>(
        _ route: RouteType,
        with options: TransitionOptions = .init(animated: true)
    ) async -> (any TransitionProtocol)? {
        await router(for: RouteType.self)?.contextTrigger(route, with: options)

    }

}

#endif

#endif
