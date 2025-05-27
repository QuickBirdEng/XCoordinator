//
//  Transition+SwiftUI.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 12.05.25.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, tvOS 13, *)
extension Transition {
    
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
