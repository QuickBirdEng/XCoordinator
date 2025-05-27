//
//  Representable.swift
//  XCoordinator
//
//  Created by Paul Johannes Kraft (QB) on 15.05.25.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, tvOS 13, *)
internal struct Representable<C: Presentable>: UIViewControllerRepresentable {
    // MARK: Stored Properties
    
    private let create: () -> C
    private let update: (UIViewController, Context) -> Void
    
    // MARK: Initialization
    
    internal init(
        create: @escaping () -> C,
        update: @escaping (UIViewController, Context) -> Void = { _, _ in }
    ) {
        self.create = create
        self.update = update
    }
    
    // MARK: Methods

    internal func makeCoordinator() -> C {
        create()
    }
    
    internal func makeUIViewController(
        context: Context
    ) -> UIViewController {
        context.coordinator.viewController
    }
    
    internal func updateUIViewController(
        _ controller: UIViewController,
        context: Context
    ) {
        update(controller, context)
    }

}

#endif
