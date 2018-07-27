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
    var rootViewController: UIViewController { get }

    func trigger(_ route: CoordinatorRoute, with options: TransitionOptions, completion: PresentationHandler?)

    func prepareTransition(for route: CoordinatorRoute) -> CoordinatorRoute.TransitionType

    func presented(from presentable: Presentable?)
}

extension Coordinator {
    public typealias TransitionType = CoordinatorRoute.TransitionType

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

    // MARK: Transitions

    func present(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        viewController.transitioningDelegate = animation
        rootViewController.present(viewController, animated: options.animated, completion: completion)
    }

    func dismiss(with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        rootViewController.transitioningDelegate = animation
        (context ?? rootViewController).dismiss(animated: options.animated, completion: completion)
    }

    func embed(_ viewController: UIViewController, in container: Container, with options: TransitionOptions, completion: PresentationHandler?) {
        container.viewController.addChildViewController(viewController)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(viewController.view)

        container.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        container.view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        container.view.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        container.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true

        viewController.didMove(toParentViewController: container.viewController)

        completion?()
    }

    func registerPeek(from sourceView: UIView, transitionGenerator: @escaping () -> TransitionType, completion: PresentationHandler?) {
        let delegate = CoordinatorPreviewingDelegateObject(transition: transitionGenerator, coordinator: AnyCoordinator<CoordinatorRoute>(self), completion: completion)

        if let existingContextIndex = sourceView.strongReferences
            .index(where: {
                $0 is CoordinatorPreviewingDelegateObject<CoordinatorRoute>
            }),
            let contextDelegate = sourceView.strongReferences.remove(at: existingContextIndex) as? CoordinatorPreviewingDelegateObject<CoordinatorRoute>,
            let context = contextDelegate.context {
            rootViewController.unregisterForPreviewing(withContext: context)
        }

        sourceView.strongReferences.append(delegate)

        delegate.context = rootViewController.registerForPreviewing(with: delegate, sourceView: sourceView)
    }

    // MARK: Helpers

    func performTransition(_ transition: TransitionType, with options: TransitionOptions, completion: PresentationHandler? = nil) {
        transition.perform(
            options: options,
            coordinator: AnyCoordinator<CoordinatorRoute>(self),
            completion: completion
        )
    }

    public func setRoot(for window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        presented(from: nil)
    }
}
