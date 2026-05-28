//
//  RoutingController.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

///
/// A `UIHostingController` subclass that bridges a SwiftUI view tree into a UIKit coordinator flow.
///
/// `RoutingController` is the SwiftUI counterpart to ``ViewCoordinator``'s root view controller: it injects
/// a ``RoutingContext`` into its hosted view's environment, and observes context updates flowing back up
/// through a `PreferenceKey` so that descendant views can register additional routers.
///
/// Use it from `prepareTransition(for:)` to push or present SwiftUI content from a UIKit coordinator:
///
/// ```swift
/// return .push(RoutingController { UserView(name: name) })
/// ```
///
public class RoutingController<Content: View>: UIHostingController<RoutingController<Content>.InjectorView>, RoutingContextProvider {

    // MARK: Nested Types

    /// The internal SwiftUI wrapper view that injects the routing context and listens for downstream changes.
    ///
    /// This type is only public because it must appear in the `UIHostingController`'s generic parameter list.
    /// Treat it as an implementation detail; do not construct or inspect it directly.
    public struct InjectorView: View {

        // MARK: Stored Properties

        private let routingContext: RoutingContext
        private let content: Content
        private let onUpdate: (RoutingContext) -> Void

        // MARK: Computed Properties

        public var body: some View {
            content
                .environment(\.routingContext, routingContext)
                .onRoutingContextChanged(perform: onUpdate)
        }

        // MARK: Initialization

        fileprivate init(
            context: RoutingContext,
            content: Content,
            onUpdate: @escaping (RoutingContext) -> Void
        ) {
            self.routingContext = context
            self.content = content
            self.onUpdate = onUpdate
        }

    }

    // MARK: Properties

    /// The routing context currently propagated into the hosted SwiftUI environment.
    public var routingContext: RoutingContext
    private var routingContent = RoutingContext()

    // MARK: Initialization

    ///
    /// Creates a routing controller that hosts the given SwiftUI view.
    ///
    /// - Parameters:
    ///   - context: The initial routing context to inject into the environment. Defaults to an empty context;
    ///     the surrounding coordinator typically populates it via `performTransition`.
    ///   - rootView: The SwiftUI view to host.
    ///
    public init(
        context: RoutingContext = .init(),
        rootView: Content
    ) {
        self.routingContext = context
        var onUpdate: ((RoutingContext) -> Void)?
        super.init(
            rootView: InjectorView(
                context: context,
                content: rootView
            ) { updatedContext in
                onUpdate?(updatedContext)
            }
        )
        onUpdate = { [weak self] updatedContext in
            self?.routingContext = updatedContext
        }
    }

    ///
    /// Creates a routing controller that hosts a SwiftUI view built with a `@ViewBuilder` closure.
    ///
    /// - Parameters:
    ///   - context: The initial routing context. Defaults to an empty context.
    ///   - rootView: The view-builder producing the hosted SwiftUI content.
    ///
    public convenience init(
        context: RoutingContext = .init(),
        @ViewBuilder rootView: () -> Content
    ) {
        self.init(context: context, rootView: rootView())
    }

    public required init?(coder aDecoder: NSCoder) {
        self.routingContext = .init()
        super.init(coder: aDecoder)
    }

}

#endif
