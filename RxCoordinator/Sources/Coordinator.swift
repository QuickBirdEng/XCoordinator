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
    func trigger(_ route: CoordinatorRoute, with options: TransitionOptions) -> TransitionObservables

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

    public func trigger(_ route: CoordinatorRoute, with options: TransitionOptions) -> TransitionObservables {
        let transition = prepareTransition(for: route)
        return performTransition(transition, with: options)
    }

    // MARK: Convenience methods

    @discardableResult
    public func trigger(_ route: CoordinatorRoute) -> TransitionObservables {
        return trigger(route, with: TransitionOptions.defaultOptions)
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

    func registerPeek<T>(from sourceView: UIView, transitionGenerator: @escaping () -> Transition<T>) -> TransitionObservables {
        guard let viewController = viewController else {
            return TransitionObservables(presentation: .empty(), dismissal: .empty())
        }

        let presentationObservable = self.presentationObservable(for: viewController)
        let dismissalObservable = self.dismissalObservable(for: viewController)

        let delegate = CoordinatorPreviewingDelegateObject(transition: transitionGenerator, coordinator: AnyCoordinator(self))
        sourceView.strongReferences.append(delegate)
        
        navigationController.registerForPreviewing(with: delegate, sourceView: sourceView)

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

    func performTransition<T>(_ transition: Transition<T>, with options: TransitionOptions) -> TransitionObservables {
        switch transition.type {
        case let transitionType as TransitionTypeVC:
            switch transitionType {
            case .present(let presentable):
                presentable.presented(from: self)
                return present(presentable.viewController, with: options, animation: transition.animation)
            case .embed(let presentable, let container):
                presentable.presented(from: self)
                return embed(presentable.viewController, in: container, with: options)
            case .registerPeek(let source, let transitionGenerator):
                return registerPeek(from: source.view, transitionGenerator: transitionGenerator)
            case .dismiss:
                return dismiss(with: options, animation: transition.animation)
            case .none:
                return TransitionObservables(presentation: .empty(), dismissal: .empty())
            }
        case let transitionType as TransitionTypeNC:
            switch transitionType {
            case .push(let presentable):
                presentable.presented(from: self)
                return push(presentable.viewController, with: options, animation: transition.animation)
            case .present(let presentable):
                presentable.presented(from: self)
                return present(presentable.viewController, with: options, animation: transition.animation)
            case .embed(let presentable, let container):
                presentable.presented(from: self)
                return embed(presentable.viewController, in: container, with: options)
            case .registerPeek(let source, let transitionGenerator):
                return registerPeek(from: source.view, transitionGenerator: transitionGenerator)
            case .pop:
                return pop(with: options, toRoot: false, animation: transition.animation)
            case .popToRoot:
                return pop(with: options, toRoot: true, animation: transition.animation)
            case .dismiss:
                return dismiss(with: options, animation: transition.animation)
            case .none:
                return TransitionObservables(presentation: .empty(), dismissal: .empty())
            }
        default:
            return TransitionObservables(presentation: .empty(), dismissal: .empty())
        }
    }

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
