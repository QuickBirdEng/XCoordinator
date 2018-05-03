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

protocol Coordinator: Presentable {
    associatedtype CoordinatorScene: Scene

    var context: UIViewController { get }
    var navigationController: UINavigationController { get }

    @discardableResult func transition(to scene: CoordinatorScene, with options: TransitionOptions) -> TransitionObservables

    func start()
}

extension Coordinator {

    public var viewController: UIViewController! {
        start()
        return navigationController
    }


    // MARK: Convenience methods

    @discardableResult
    public func transition(to scene: CoordinatorScene) -> TransitionObservables {
        return transition(to: scene, with: TransitionOptions.defaultOptions)
    }

    public func start() {}

    // MARK: Implementations

    @discardableResult
    public func transition(to scene: CoordinatorScene, with options: TransitionOptions) -> TransitionObservables {
        let transition = scene.prepareTransition()

        switch transition.type {
        case .push(let viewController):
            return push(viewController, with: options, animation: transition.animation)
        case .present(let viewController):
            return present(viewController, with: options, animation: transition.animation)
        case .embed(let viewController, let container):
            return embed(viewController, in: container, with: options)
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


    // MARK: Transitions

    private func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?) -> TransitionObservables {
        let presentationObservable = navigationController.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in () }
            .take(1)

        let dismissalObservable = self.dismissalObservable(for: viewController)

        viewController.transitioningDelegate = animation
        navigationController.pushViewController(viewController, animated: options.animated)

        return TransitionObservables(presentation: presentationObservable, dismissal: dismissalObservable)
    }

    private func present(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?) -> TransitionObservables {
        let presentationObservable = self.presentationObservable(for: viewController)
        let dismissalObservable = self.dismissalObservable(for: viewController)

        viewController.transitioningDelegate = animation
        navigationController.present(viewController, animated: options.animated, completion: nil)

        return TransitionObservables(presentation: presentationObservable, dismissal: dismissalObservable)
    }

    private func pop(with options: TransitionOptions, toRoot: Bool, animation: Animation?) -> TransitionObservables {
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

    private func dismiss(with options: TransitionOptions, animation: Animation?) -> TransitionObservables {
        navigationController.transitioningDelegate = animation
        let transitionObservable = Observable<Void>.create { [unowned context] observer -> Disposable in
            context.dismiss(animated: options.animated, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }

        return TransitionObservables(presentation: transitionObservable, dismissal: transitionObservable)
    }

    private func embed(_ viewController: UIViewController, in container: Container, with options: TransitionOptions) -> TransitionObservables {
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
