//
//  View+Trigger.swift
//  XCoordinator
//
//  Created by Paul Kraft on 09.05.2025.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

private struct TriggerViewModifier<Item: Equatable, RouteType: Route>: ViewModifier {

    // MARK: Properties

    let item: Item
    let priority: TaskPriority
    let skipFirst: Bool
    let route: () -> RouteType?
    let options: () -> TransitionOptions
    let onCompleted: () async -> Void

    @Routing<RouteType> private var router
    @State private var isFirstCall = true

    // MARK: Methods

    func body(content: Content) -> some View {
        content.task(id: item, priority: priority) {
            let wasFirst = isFirstCall
            isFirstCall = false
            guard !(skipFirst && wasFirst) else {
                return
            }
            guard let route = route() else {
                return
            }
            await router.trigger(route, with: options())
            await onCompleted()
        }
    }

}

extension View {

    ///
    /// Triggers the given route once when the view first appears.
    ///
    /// Resolves the router for `RouteType` via `@Routing` and fires the route from within a `.task`.
    /// Returning `nil` from the `route` closure suppresses the trigger.
    ///
    /// - Parameters:
    ///   - priority: The task priority used to run the trigger. Defaults to `.userInitiated`.
    ///   - route: An auto-closure producing the route to trigger. Re-evaluated each time the task runs.
    ///   - options: An auto-closure producing the transition options. Defaults to `.init(animated: true)`.
    ///   - onCompleted: An async closure invoked after the transition completes.
    /// - Returns: A view that triggers the route on first appearance.
    ///
    public func triggerOnAppear<RouteType: Route>(
        priority: TaskPriority = .userInitiated,
        route: @autoclosure @escaping () -> RouteType?,
        with options: @autoclosure @escaping () -> TransitionOptions = TransitionOptions(animated: true),
        onCompleted: @escaping () async -> Void = {}
    ) -> some View {
        self.modifier(
            TriggerViewModifier(
                item: true,
                priority: priority,
                skipFirst: false,
                route: route,
                options: options,
                onCompleted: onCompleted
            )
        )
    }

    ///
    /// Triggers the given route whenever `item` changes, skipping the initial value.
    ///
    /// Useful for kicking off a navigation in response to a model change. The first invocation
    /// (when the view appears with its initial `item`) is intentionally skipped to avoid firing
    /// during the initial render.
    ///
    /// - Parameters:
    ///   - item: The value whose changes drive the trigger.
    ///   - priority: The task priority used to run the trigger. Defaults to `.userInitiated`.
    ///   - route: An auto-closure producing the route to trigger.
    ///   - options: An auto-closure producing the transition options. Defaults to `.init(animated: true)`.
    ///   - onCompleted: An async closure invoked after the transition completes.
    /// - Returns: A view that triggers the route whenever `item` changes.
    ///
    public func triggerOnChange<Item: Equatable, RouteType: Route>(
        of item: Item,
        priority: TaskPriority = .userInitiated,
        route: @autoclosure @escaping () -> RouteType?,
        with options: @autoclosure @escaping () -> TransitionOptions = TransitionOptions(animated: true),
        onCompleted: @escaping () async -> Void = {}
    ) -> some View {
        self.modifier(
            TriggerViewModifier(
                item: item,
                priority: priority,
                skipFirst: true,
                route: route,
                options: options,
                onCompleted: onCompleted
            )
        )
    }

    ///
    /// Triggers the given route when `condition` becomes `true`.
    ///
    /// The route is only fired when `condition` transitions to `true`; setting it back to `false`
    /// does not trigger another transition. Like ``triggerOnChange(of:priority:route:with:onCompleted:)``,
    /// the initial value is skipped.
    ///
    /// - Parameters:
    ///   - condition: The boolean whose `true` transitions drive the trigger.
    ///   - priority: The task priority used to run the trigger. Defaults to `.userInitiated`.
    ///   - route: An auto-closure producing the route to trigger when `condition` is `true`.
    ///   - options: An auto-closure producing the transition options. Defaults to `.init(animated: true)`.
    ///   - onCompleted: An async closure invoked after the transition completes.
    /// - Returns: A view that triggers the route whenever `condition` becomes `true`.
    ///
    public func trigger<RouteType: Route>(
        when condition: Bool,
        priority: TaskPriority = .userInitiated,
        route: @autoclosure @escaping () -> RouteType,
        with options: @autoclosure @escaping () -> TransitionOptions = TransitionOptions(animated: true),
        onCompleted: @escaping () async -> Void = {}
    ) -> some View {
        self.modifier(
            TriggerViewModifier(
                item: condition,
                priority: priority,
                skipFirst: true,
                route: {
                    condition ? route() : nil
                },
                options: options,
                onCompleted: onCompleted
            )
        )
    }
}

#endif
