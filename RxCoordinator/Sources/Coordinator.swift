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

    var context: UIViewController! { get }
    var rootViewController: UIViewController { get }

    func trigger(_ route: CoordinatorRoute, with options: TransitionOptions, completion: PresentationHandler?)

    func prepareTransition(for route: CoordinatorRoute) -> Transition<CoordinatorRoute.RootType>

    func presented(from presentable: Presentable?)
}

extension Coordinator {

    public var viewController: UIViewController! {
        return rootViewController
    }

    var navigationController: UINavigationController {
        return viewController as! UINavigationController
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

    func registerPeek<T>(from sourceView: UIView, transitionGenerator: @escaping () -> Transition<T>, completion: PresentationHandler?) {
        let delegate = CoordinatorPreviewingDelegateObject(transition: transitionGenerator, coordinator: AnyCoordinator(self), completion: completion)
        sourceView.strongReferences.append(delegate)

        navigationController.registerForPreviewing(with: delegate, sourceView: sourceView)
    }

    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        viewController.transitioningDelegate = animation
        navigationController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(with options: TransitionOptions, toRoot: Bool, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let currentVC = navigationController.visibleViewController
        currentVC?.transitioningDelegate = animation
        if toRoot {
            navigationController.popToRootViewController(animated: options.animated)
        } else {
            navigationController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }

    // MARK: Helpers

    func performTransition<T>(_ transition: Transition<T>, with options: TransitionOptions, completion: PresentationHandler? = nil) {
        transition.type.performTransition(options: options, animation: transition.animation,
                                          coordinator: AnyCoordinator(self), completion: completion)
    }

    public func setRoot(for window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        presented(from: nil)
    }
}
