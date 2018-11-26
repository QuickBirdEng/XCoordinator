//
//  Coordinator+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer {
    func present(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        rootViewController.present(viewController, animated: options.animated, completion: completion)
    }

    func dismiss(with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        if let animation = animation {
            let presentedViewController = rootViewController.presentedViewController ?? rootViewController
            presentedViewController.transitioningDelegate = animation
        }
        rootViewController.dismiss(animated: options.animated, completion: completion)
    }

    func embed(_ viewController: UIViewController, in container: Container, with options: TransitionOptions, completion: PresentationHandler?) {

        container.viewController.addChild(viewController)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(viewController.view)

        NSLayoutConstraint.activate([
            container.view.leadingAnchor
                .constraint(equalTo: viewController.view.leadingAnchor),
            container.view.rightAnchor
                .constraint(equalTo: viewController.view.rightAnchor),
            container.view.topAnchor
                .constraint(equalTo: viewController.view.topAnchor),
            container.view.bottomAnchor
                .constraint(equalTo: viewController.view.bottomAnchor)
        ])

        viewController.didMove(toParent: container.viewController)

        completion?()
    }
}

extension AnyTransitionPerformer {
    func registerPeek(from sourceView: UIView, transitionGenerator: @escaping () -> TransitionType, completion: PresentationHandler?) {
        let delegate = CoordinatorPreviewingDelegateObject(transition: transitionGenerator, performer: self, completion: completion)

        if let context = sourceView.removePreviewingContext(for: TransitionType.self) {
            rootViewController.unregisterForPreviewing(withContext: context)
        }

        sourceView.strongReferences.append(delegate)
        delegate.context = rootViewController.registerForPreviewing(with: delegate, sourceView: sourceView)
    }
}
