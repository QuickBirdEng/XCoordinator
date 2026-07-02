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
/// An observable wrapper around a ``RoutingContext`` so that updates made after a
/// ``RoutingController`` has been created (e.g. a coordinator registering itself during
/// `performTransition`, or routers merged back up through a `PreferenceKey`) are re-injected
/// into the hosted SwiftUI environment.
///
/// `RoutingContext` is a value type, so storing it in a plain property captures a snapshot.
/// Routing every mutation through this reference type lets SwiftUI observe the change and
/// re-evaluate the injecting view.
///
@MainActor
internal final class RoutingContextBox: ObservableObject {
    @Published var context: RoutingContext

    init(_ context: RoutingContext) {
        self.context = context
    }
}

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

        @ObservedObject private var box: RoutingContextBox
        private let content: Content
        private let onUpdate: (RoutingContext) -> Void

        // MARK: Computed Properties

        public var body: some View {
            content
                .environment(\.routingContext, box.context)
                .onRoutingContextChanged(perform: onUpdate)
        }

        // MARK: Initialization

        fileprivate init(
            box: RoutingContextBox,
            content: Content,
            onUpdate: @escaping (RoutingContext) -> Void
        ) {
            self._box = ObservedObject(wrappedValue: box)
            self.content = content
            self.onUpdate = onUpdate
        }

    }

    // MARK: Properties

    private let box: RoutingContextBox

    /// The routing context currently propagated into the hosted SwiftUI environment.
    ///
    /// Mutating it (e.g. via `routingContext.add(_:)`) re-injects the updated context into the
    /// hosted SwiftUI environment, so descendant `@Routing` lookups resolve against the latest routers.
    public var routingContext: RoutingContext {
        get { box.context }
        set { box.context = newValue }
    }

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
        let box = RoutingContextBox(context)
        self.box = box
        super.init(
            rootView: InjectorView(
                box: box,
                content: rootView
            ) { [box] updatedContext in
                // Merge routers flowing UP via the PreferenceKey back into the injected context.
                box.context.add(updatedContext)
            }
        )
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
        self.box = RoutingContextBox(.init())
        super.init(coder: aDecoder)
    }

}

#endif
