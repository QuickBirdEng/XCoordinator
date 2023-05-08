//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

struct Perform<RootViewController, TransitionType: TransitionComponent> {

    // MARK: Stored Properties

    private let transition: () -> Transition<TransitionType.RootViewController>
    private let rootViewController: TransitionType.RootViewController

    // MARK: Initialization

    public init(
        on rootViewController: TransitionType.RootViewController,
        @TransitionBuilder<TransitionType.RootViewController> transition: @escaping () -> TransitionGroup<TransitionType.RootViewController>
    ) {
        self.rootViewController = rootViewController
        self.transition = { transition().build() }
    }

}

extension Perform: TransitionComponent where RootViewController: UIViewController {

    func build() -> Transition<RootViewController> {
        let transition = transition()
        return Transition(presentables: transition.presentables, animationInUse: transition.animation) { _, options, completion in
            transition.perform(on: rootViewController, with: options, completion: completion)
        }
    }

}
