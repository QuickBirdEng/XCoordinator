//
//  Router+Binding.swift
//  XCoordinator
//
//  Created by Paul Kraft on 09.05.2025.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 15, tvOS 15, *)
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
            guard skipFirst || !isFirstCall else {
                isFirstCall = false
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

@available(iOS 15, tvOS 15, *)
extension View {
    
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
    
    public func trigger<Item: Equatable, RouteType: Route>(
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
