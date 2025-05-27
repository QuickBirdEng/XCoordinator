//
//  RepresentableContext.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 20.05.25.
//

#if canImport(SwiftUI)

import SwiftUI
import UIKit

@MainActor
@available(iOS 13, tvOS 13, *)
public protocol RepresentableContext<Coordinator> {
    associatedtype Coordinator = Void
    
    var coordinator: Coordinator { get }
    var transaction: Transaction { get }
    var environment: EnvironmentValues { get }

    @available(iOS 18.0, tvOS 18.0, visionOS 2.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    func animate(changes: () -> Void, completion: (() -> Void)?)
}

@available(iOS 13, tvOS 13, *)
extension UIViewControllerRepresentableContext: RepresentableContext {
    public typealias Coordinator = Representable.Coordinator
}

@available(iOS 13, tvOS 13, *)
extension UIViewRepresentableContext: RepresentableContext {
    public typealias Coordinator = Representable.Coordinator
}

#endif
