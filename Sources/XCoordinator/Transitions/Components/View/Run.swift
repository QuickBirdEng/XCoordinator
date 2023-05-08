//
//  File.swift
//  
//
//  Created by Paul Kraft on 09.05.23.
//

#if swift(>=5.5.2)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public struct Run<RootViewController> {

    // MARK: Stored Properties

    private let presentables: [any Presentable]
    private let animationInUse: TransitionAnimation?
    private let priority: TaskPriority?
    private let action: () async -> Void

    // MARK: Initialization

    public init(
        presentables: [any Presentable] = [],
        animationInUse: TransitionAnimation? = nil,
        priority: TaskPriority? = nil,
        _ action: @escaping () -> Void
    ) {
        self.presentables = presentables
        self.animationInUse = animationInUse
        self.priority = priority
        self.action = action
    }

}

@available(iOS 13.0, tvOS 13.0, *)
extension Run: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        Transition(presentables: presentables, animationInUse: animationInUse) { _, _, completion in
            Task(priority: priority) { @MainActor in
                await action()
                completion?()
            }
        }
    }

}

#endif
