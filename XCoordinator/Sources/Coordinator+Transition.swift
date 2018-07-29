//
//  Coordinator+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//

extension Coordinator {
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

        viewController.didMove(toParentViewController: container.viewController)

        completion?()
    }

    func registerPeek(from sourceView: UIView, transitionGenerator: @escaping () -> TransitionType, completion: PresentationHandler?) {
        let delegate = CoordinatorPreviewingDelegateObject(transition: transitionGenerator, coordinator: self, completion: completion)

        if let existingContextIndex = sourceView.strongReferences
            .index(where: {
                $0 is CoordinatorPreviewingDelegateObject<Self>
            }),
            let contextDelegate = sourceView.strongReferences.remove(at: existingContextIndex) as? CoordinatorPreviewingDelegateObject<Self>,
            let context = contextDelegate.context {
            rootViewController.unregisterForPreviewing(withContext: context)
        }

        sourceView.strongReferences.append(delegate)

        delegate.context = rootViewController.registerForPreviewing(with: delegate, sourceView: sourceView)
    }
}
