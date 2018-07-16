//
//  Coordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol Coordinator: Presentable {
    associatedtype CoordinatorRoute: Route

    var context: UIViewController! { get }
    var rootViewController: UIViewController { get }

    @discardableResult
    func transition(to route: CoordinatorRoute, with options: TransitionOptions) -> TransitionObservables

    func presented(from presentable: Presentable?)
}

extension Coordinator where CoordinatorRoute.RootType == TransitionTypeVC {

    @discardableResult
    public func transition(to route: CoordinatorRoute, with options: TransitionOptions) -> TransitionObservables {
        let transition = route.prepareTransition(coordinator: AnyCoordinator(self))

        switch transition.type {
        case .present(let presentable):
            presentable.presented(from: self)
            return present(presentable.viewController, with: options, animation: transition.animation)
        case .embed(let presentable, let container):
            presentable.presented(from: self)
            return embed(presentable.viewController, in: container, with: options)
        case .dismiss:
            return dismiss(with: options, animation: transition.animation)
        case .none:
            return TransitionObservables(presentation: .empty(), dismissal: .empty())
        }
    }

}

extension Coordinator where CoordinatorRoute.RootType == TransitionTypeNC {

    @discardableResult
    public func transition(to route: CoordinatorRoute, with options: TransitionOptions) -> TransitionObservables {
        let transition = route.prepareTransition(coordinator: AnyCoordinator(self))

        switch transition.type {
        case .push(let presentable):
            presentable.presented(from: self)
            return push(presentable.viewController, with: options, animation: transition.animation)
        case .present(let presentable):
            presentable.presented(from: self)
            return present(presentable.viewController, with: options, animation: transition.animation)
        case .embed(let presentable, let container):
            presentable.presented(from: self)
            return embed(presentable.viewController, in: container, with: options)
        case .pop:
            return pop(with: options, toRoot: false, animation: transition.animation)
        case .popToRoot:
            return pop(with: options, toRoot: true, animation: transition.animation)
        case .dismiss:
            return dismiss(with: options, animation: transition.animation)
        case .none:
            return TransitionObservables(presentation: .empty(), dismissal: .empty())
        }
    }

}

extension Coordinator {

    public var viewController: UIViewController! {
        return rootViewController
    }

    var navigationController: UINavigationController {
        return viewController as! UINavigationController
    }

    public func presented(from presentable: Presentable?) {}

    // MARK: Convenience methods

    @discardableResult
    public func transition(to route: CoordinatorRoute) -> TransitionObservables {
        return transition(to: route, with: TransitionOptions.defaultOptions)
    }

    // MARK: Transitions

    func present(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?) -> TransitionObservables {
        let presentationObservable = self.presentationObservable(for: viewController)
        let dismissalObservable = self.dismissalObservable(for: viewController)

        viewController.transitioningDelegate = animation
        rootViewController.present(viewController, animated: options.animated, completion: nil)

        return TransitionObservables(presentation: presentationObservable, dismissal: dismissalObservable)
    }

    func dismiss(with options: TransitionOptions, animation: Animation?) -> TransitionObservables {
        rootViewController.transitioningDelegate = animation

        let transitionObservable = Observable<Void>.empty()

        context.dismiss(animated: options.animated, completion: nil)

        return TransitionObservables(presentation: transitionObservable, dismissal: transitionObservable)
    }

    func embed(_ viewController: UIViewController, in container: Container, with options: TransitionOptions) -> TransitionObservables {
        let presentationObservable = self.presentationObservable(for: viewController)
        let dismissalObservable = self.dismissalObservable(for: viewController)

        container.viewController.addChildViewController(viewController)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(viewController.view)

        container.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        container.view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        container.view.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        container.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true

        viewController.didMove(toParentViewController: container.viewController)

        return TransitionObservables(presentation: presentationObservable, dismissal: dismissalObservable)
    }

    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?) -> TransitionObservables {
        let presentationObservable = navigationController.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in () }
            .take(1)

        let dismissalObservable = self.dismissalObservable(for: viewController)

        viewController.transitioningDelegate = animation
        navigationController.pushViewController(viewController, animated: options.animated)

        return TransitionObservables(presentation: presentationObservable, dismissal: dismissalObservable)
    }

    func pop(with options: TransitionOptions, toRoot: Bool, animation: Animation?) -> TransitionObservables {
        let transitionObservable = navigationController.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in () }
            .take(1)

        let currentVC = navigationController.visibleViewController
        currentVC?.transitioningDelegate = animation
        if toRoot {
            navigationController.popToRootViewController(animated: options.animated)
        } else {
            navigationController.popViewController(animated: options.animated)
        }

        return TransitionObservables(presentation: transitionObservable, dismissal: transitionObservable)
    }

    // MARK: Helpers

    private func presentationObservable(for viewController: UIViewController) -> Observable<Void> {
        return viewController.rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .map { _ in () }
            .take(1)
    }

    private func dismissalObservable(for viewController: UIViewController) -> Observable<Void> {
        return viewController.rx.sentMessage(#selector(UIViewController.viewWillDisappear))
            .filter { _ in viewController.isBeingDismissed }
            .map { _ in () }
            .take(1)
    }
}
