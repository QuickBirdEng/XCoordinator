//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct Redirect<RootViewController, CoordinatorType: Coordinator> {

    // MARK: Stored Properties

    private let coordinator: CoordinatorType
    private let route: CoordinatorType.RouteType

    // MARK: Initialization

    public init(as route: CoordinatorType.RouteType, to coordinator: CoordinatorType) {
        self.coordinator = coordinator
        self.route = route
    }

}

extension Redirect: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        let transition = coordinator.prepareTransition(for: route)
        return Transition(presentables: transition.presentables,
                          animationInUse: transition.animation
        ) { _, options, completion in
            coordinator.performTransition(transition, with: options, completion: completion)
        }
    }

}
