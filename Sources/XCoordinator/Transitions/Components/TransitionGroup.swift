//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct TransitionGroup<RootViewController: UIViewController>: TransitionComponent {

    // MARK: Stored Properties

    private let transitions: [() -> Transition<RootViewController>]

    // MARK: Initialization

    init(_ transition: some TransitionComponent<RootViewController>) {
        self.transitions = [transition.build]
    }

    init(_ transitions: [() -> Transition<RootViewController>]) {
        self.transitions = transitions
    }

    // MARK: Methods

    public func build() -> Transition<RootViewController> {
        .multiple(transitions.map { $0() })
    }

}
