//
//  RepresentableContext.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 20.05.25.
//

#if canImport(SwiftUI)

import SwiftUI
import UIKit

///
/// A common abstraction over the SwiftUI representable contexts.
///
/// Both `UIViewControllerRepresentableContext` and `UIViewRepresentableContext` conform to
/// `RepresentableContext`, which lets callers handle either context type with the same code path.
///
@MainActor
public protocol RepresentableContext<Coordinator> {

    /// The representable's coordinator instance.
    associatedtype Coordinator = Void

    /// The coordinator instance produced by `makeCoordinator()`.
    var coordinator: Coordinator { get }

    /// The current SwiftUI transaction associated with this update.
    var transaction: Transaction { get }

    /// The SwiftUI environment values at the point of this update.
    var environment: EnvironmentValues { get }

    ///
    /// Runs the given changes inside a SwiftUI animation, calling the completion handler when it finishes.
    ///
    /// This bridges the iOS 18 `animate(changes:completion:)` API onto the representable contexts
    /// so that callers can use it uniformly via the protocol.
    ///
    /// - Parameters:
    ///   - changes: The state mutations to animate.
    ///   - completion: A closure invoked once the animation has completed.
    ///
    @available(iOS 18.0, tvOS 18.0, visionOS 2.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    func animate(changes: () -> Void, completion: (() -> Void)?)
}

extension UIViewControllerRepresentableContext: RepresentableContext {
    public typealias Coordinator = Representable.Coordinator
}

extension UIViewRepresentableContext: RepresentableContext {
    public typealias Coordinator = Representable.Coordinator
}

#endif
