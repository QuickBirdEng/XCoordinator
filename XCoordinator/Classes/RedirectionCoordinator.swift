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

    public init(viewController: UIViewController,
                superTransitionPerformer: AnyTransitionPerformer<TransitionType>,
                prepareTransition: ((RouteType) -> TransitionType)?) {

        viewControllerBox.set(viewController)
        self.superTransitionPerformer = superTransitionPerformer
        _prepareTransition = prepareTransition
    }

    public init<T: TransitionPerformer>(viewController: UIViewController,
                                        superTransitionPerformer: T,
                                        prepareTransition: ((RouteType) -> TransitionType)?
        ) where T.TransitionType == TransitionType {

        viewControllerBox.set(viewController)
        self.superTransitionPerformer = AnyTransitionPerformer(superTransitionPerformer)
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

    public func performTransition(_ transition: TransitionType,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler?) {
        superTransitionPerformer.performTransition(transition, with: options, completion: completion)
    }
}

// MARK: - Deprecated

extension RedirectionCoordinator {
    @available(*, deprecated, renamed: "init(viewController:superTransitionPerfomer:prepareTransition:)")
    public convenience init<C: Coordinator>(viewController: UIViewController,
                                            superCoordinator: C,
                                            prepareTransition: ((RouteType) -> TransitionType)?) where C.TransitionType == TransitionType {
        self.init(viewController: viewController,
                  superTransitionPerformer: AnyTransitionPerformer(superCoordinator),
                  prepareTransition: prepareTransition)
    }
}
