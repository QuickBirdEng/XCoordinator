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

        // Detect first app start and call presented method manually
        // App doesn't have key window set yet, but the coordinators rootViewController has already it's window
        if UIApplication.shared.keyWindow == nil && rootViewController.view.window != nil {
            DispatchQueue.main.async {
                self.presented(from: nil)
            }
        }
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
        context.dismiss(animated: options.animated, completion: completion)
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
        switch transition.type {
        case let transitionType as TransitionTypeVC:
            switch transitionType {
            case .present(let presentable):
                presentable.presented(from: self)
                return present(presentable.viewController, with: options, animation: transition.animation, completion: completion)
            case .embed(let presentable, let container):
                presentable.presented(from: self)
                return embed(presentable.viewController, in: container, with: options, completion: completion)
            case .registerPeek(let source, let transitionGenerator):
                return registerPeek(from: source.view, transitionGenerator: transitionGenerator, completion: completion)
            case .dismiss:
                return dismiss(with: options, animation: transition.animation, completion: completion)
            case .none:
                return
            }
        case let transitionType as TransitionTypeNC:
            switch transitionType {
            case .push(let presentable):
                presentable.presented(from: self)
                return push(presentable.viewController, with: options, animation: transition.animation, completion: completion)
            case .present(let presentable):
                presentable.presented(from: self)
                return present(presentable.viewController, with: options, animation: transition.animation, completion: completion)
            case .embed(let presentable, let container):
                presentable.presented(from: self)
                return embed(presentable.viewController, in: container, with: options, completion: completion)
            case .registerPeek(let source, let transitionGenerator):
                return registerPeek(from: source.view, transitionGenerator: transitionGenerator, completion: completion)
            case .pop:
                return pop(with: options, toRoot: false, animation: transition.animation, completion: completion)
            case .popToRoot:
                return pop(with: options, toRoot: true, animation: transition.animation, completion: completion)
            case .dismiss:
                return dismiss(with: options, animation: transition.animation, completion: completion)
            case .none:
                return
            }
        default:
            print("Unknown tranisition type can't be handled. Ignoring transition...")
            return
        }
    }

}
