//
//  Coordinator+SplitView.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

extension Coordinator where TransitionType == SplitViewTransition {
    func show(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.transitioningDelegate = animation
        rootViewController.show(viewController, sender: nil)

        CATransaction.commit()
    }

    func showDetail(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        rootViewController.transitioningDelegate = animation
        rootViewController.showDetailViewController(viewController, sender: nil)

        CATransaction.commit()
    }
}
