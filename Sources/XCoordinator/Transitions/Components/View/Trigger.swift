//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct Trigger<RootViewController, RouteType: Route> {

    // MARK: Stored Properties

    private let router: any Router<RouteType>
    private let route: RouteType

    // MARK: Initialization

    public init(_ route: RouteType, on router: any Router<RouteType>) {
        self.router = router
        self.route = route
    }

}

extension Trigger: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        Transition(presentables: [], animationInUse: nil) { _, options, completion in
            router.trigger(route, with: options, completion: completion)
        }
    }

}
