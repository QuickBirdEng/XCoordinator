//
//  RedirectionCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

open class RedirectionCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let superTransitionPerformer: AnyTransitionPerformer<TransitionType>
    private let viewControllerBox = ReferenceBox<UIViewController>()
    private let _prepareTransition: ((RouteType) -> TransitionType)?

    // MARK: - Computed properties

    public var rootViewController: TransitionType.RootViewController {
        return superTransitionPerformer.rootViewController
    }

    open var viewController: UIViewController! {
        return viewControllerBox.get()
    }

    // MARK: - Init

    public init<C: Coordinator>(viewController: UIViewController, superCoordinator: C, prepareTransition: ((RouteType) -> TransitionType)? = nil) where C.TransitionType == TransitionType {
        viewControllerBox.set(viewController)
        superTransitionPerformer = AnyTransitionPerformer(superCoordinator)
        _prepareTransition = prepareTransition
    }

    // MARK: - Methods

    open func presented(from presentable: Presentable?) {
        viewController?.presented(from: presentable)
        viewControllerBox.releaseStrongReference()
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        guard let prepareTransition = _prepareTransition else {
            fatalError("Please override \(#function) or provide a prepareTransition-closure in the initializer.")
        }
        return prepareTransition(route)
    }

    func performTransition(_ transition: TransitionType, with options: TransitionOptions, completion: PresentationHandler?) {
        superTransitionPerformer.performTransition(transition, with: options, completion: completion)
    }
}
