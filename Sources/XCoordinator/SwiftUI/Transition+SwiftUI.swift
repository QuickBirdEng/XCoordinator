//
//  Transition+SwiftUI.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 12.05.25.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

extension Transition {

    ///
    /// Creates a transition that performs a SwiftUI state change instead of a UIKit transition.
    ///
    /// Use this in `prepareTransition(for:)` when a route should mutate SwiftUI state (e.g. a
    /// `@Binding` stored on the coordinator) rather than push/present a view controller. The body
    /// closure runs inside `SwiftUI.withAnimation`, and the transition's `TransitionOptions.animated`
    /// flag is respected — when `false`, no animation is applied.
    ///
    /// On iOS 17+/tvOS 17+ the completion handler fires from SwiftUI's animation-completion callback;
    /// on earlier OSes it is invoked synchronously after the state change.
    ///
    /// - Parameters:
    ///   - animation: The SwiftUI animation to use when `TransitionOptions.animated` is `true`.
    ///     Defaults to `.default`. Pass `nil` to apply no animation even when animations are enabled.
    ///   - body: The state mutations to perform.
    /// - Returns: A transition with no presentables that drives SwiftUI animations.
    ///
    public static func withAnimation(
        animation: SwiftUI.Animation? = .default,
        _ body: @MainActor @escaping () -> Void
    ) -> Transition {
        return Transition(
            presentables: [],
            animationInUse: nil,
        ) { _, options, completion in
            if #available(iOS 17, tvOS 17, *) {
                SwiftUI.withAnimation(
                    options.animated ? animation : nil
                ) {
                    body()
                } completion: {
                    completion?()
                }
            } else {
                SwiftUI.withAnimation(
                    options.animated ? animation : nil
                ) {
                    body()
                }
                completion?()
            }
        }
    }

    ///
    /// Creates a transition that performs a SwiftUI state change inside a given `Transaction`.
    ///
    /// This is the lower-level counterpart to ``withAnimation(animation:_:)`` — use it when you need
    /// fine-grained control over the SwiftUI transaction (for example to set explicit
    /// `Transaction.disablesAnimations`). The transaction's `disablesAnimations` flag is overwritten
    /// to match `TransitionOptions.animated`.
    ///
    /// On iOS 17+/tvOS 17+ the completion handler fires from the transaction's animation-completion
    /// callback; on earlier OSes it is invoked synchronously after the state change.
    ///
    /// - Parameters:
    ///   - transaction: An auto-closure producing the transaction to use. Re-evaluated each time
    ///     the transition is performed.
    ///   - body: The state mutations to perform inside the transaction.
    /// - Returns: A transition with no presentables that wraps the body in `SwiftUI.withTransaction`.
    ///
    public static func withTransaction(
        _ transaction: @autoclosure @escaping () -> Transaction,
        body: @MainActor @escaping () -> Void
    ) -> Transition {
        return Transition(
            presentables: [],
            animationInUse: nil,
        ) { _, options, completion in
            var transaction = transaction()
            transaction.disablesAnimations = !options.animated
            if #available(iOS 17, tvOS 17, *) {
                transaction.addAnimationCompletion {
                    completion?()
                }
            }
            SwiftUI.withTransaction(transaction) {
                body()
            }
            if #unavailable(iOS 17, tvOS 17) {
                completion?()
            }
        }
    }

}

#endif
