//
//  Coordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public typealias PresentationHandler = () -> Void

public protocol Coordinator: Presentable {
    associatedtype CoordinatorRoute: Route

    var context: UIViewController? { get } // TODO: Is this actually needed for every Coordinator?
    var rootViewController: RootViewController { get }

    func trigger(_ route: CoordinatorRoute, with options: TransitionOptions, completion: PresentationHandler?)

    func prepareTransition(for route: CoordinatorRoute) -> TransitionType

    func presented(from presentable: Presentable?)
}

extension Coordinator {
    public typealias TransitionType = CoordinatorRoute.TransitionType
    public typealias RootViewController = TransitionType.RootViewController

    public var viewController: UIViewController! {
        return rootViewController
    }

    public func presented(from presentable: Presentable?) {}

    public func trigger(_ route: CoordinatorRoute, with options: TransitionOptions, completion: PresentationHandler?) {
        let transition = prepareTransition(for: route)
        performTransition(transition, with: options, completion: completion)
    }

    // MARK: Convenience methods

    public func trigger(_ route: CoordinatorRoute, completion: PresentationHandler? = nil)  {
        return trigger(route, with: TransitionOptions.default, completion: completion)
    }

    // MARK: Helpers

    func performTransition(_ transition: TransitionType, with options: TransitionOptions, completion: PresentationHandler? = nil) {
        transition.perform(options: options, coordinator: self, completion: completion)
    }

    public func setRoot(for window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        presented(from: nil)
    }
}
