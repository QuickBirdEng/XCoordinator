//
//  Coordinator+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension UIViewController {

    private var topPresentedViewController: UIViewController? {
        return presentedViewController?.topPresentedViewController ?? presentedViewController
    }

    func show(_ viewController: UIViewController,
              with options: TransitionOptions,
              completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        show(viewController, sender: nil)

        CATransaction.commit()
    }

    func showDetail(_ viewController: UIViewController,
                    with options: TransitionOptions,
                    completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        showDetailViewController(viewController, sender: nil)

        CATransaction.commit()
    }

    func present(onRoot: Bool,
                 _ viewController: UIViewController,
                 with options: TransitionOptions,
                 animation: Animation?,
                 completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        let presentingViewController = onRoot
            ? self
            : (topPresentedViewController ?? self)
        presentingViewController.present(viewController, animated: options.animated, completion: completion)
    }

    func dismiss(toRoot: Bool,
                 with options: TransitionOptions,
                 animation: Animation?,
                 completion: PresentationHandler?) {
        let presentedViewController = topPresentedViewController ?? self
        if let animation = animation {
            presentedViewController.transitioningDelegate = animation
        }
        let dismissalViewController = toRoot ? self : presentedViewController
        dismissalViewController.dismiss(animated: options.animated, completion: completion)
    }

    func embed(_ viewController: UIViewController,
               in container: Container,
               with options: TransitionOptions,
               completion: PresentationHandler?) {
        container.viewController.addChild(viewController)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(viewController.view)

        // swiftlint:disable force_unwrapping
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: container.view!, attribute: .leading, relatedBy: .equal,
                               toItem: viewController.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container.view!, attribute: .trailing, relatedBy: .equal,
                               toItem: viewController.view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container.view!, attribute: .top, relatedBy: .equal,
                               toItem: viewController.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container.view!, attribute: .bottom, relatedBy: .equal,
                               toItem: viewController.view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        // swiftlint:enable force_unwrapping

        viewController.didMove(toParent: container.viewController)

        completion?()
    }
}

extension Presentable where Self: UIViewController {

    @available(iOS 9.0, *)
    func registerPeek<TransitionType: TransitionProtocol>(
        from sourceView: UIView,
        transitionGenerator: @escaping () -> TransitionType,
        completion: PresentationHandler?) where TransitionType.RootViewController == Self {
        let delegate = CoordinatorPreviewingDelegateObject(
            transition: transitionGenerator,
            rootViewController: self,
            completion: completion
        )

        if let context = sourceView.removePreviewingContext(for: TransitionType.self) {
            unregisterForPreviewing(withContext: context)
        }

        sourceView.strongReferences.append(delegate)
        delegate.context = registerForPreviewing(with: delegate, sourceView: sourceView)
    }
}
