//
//  Coordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias PresentationHandler = () -> Void

public protocol Coordinator: RouteTrigger, TransitionPerformer {
    func prepareTransition(for route: RouteType) -> TransitionType
}

// MARK: - Extension Coordinator: Presentable

extension Coordinator {
    public var viewController: UIViewController! {
        return rootViewController
    }
}

// MARK: - Extension: Helpers

extension Coordinator {
    public typealias RootViewController = TransitionType.RootViewController

    public var anyCoordinator: AnyCoordinator<RouteType> {
        return AnyCoordinator(self)
    }

    public func setRoot(for window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        presented(from: window)
    }
}

// MARK: - Extension: Default implementations

extension Coordinator {
    public func presented(from presentable: Presentable?) {}

    public func trigger(_ route: RouteType, with options: TransitionOptions, completion: PresentationHandler?) {
        let transition = prepareTransition(for: route)
        performTransition(transition, with: options, completion: completion)
    }

    func performTransition(_ transition: TransitionType, with options: TransitionOptions, completion: PresentationHandler? = nil) {
        transition.perform(options: options, coordinator: self, completion: completion)
    }
}
