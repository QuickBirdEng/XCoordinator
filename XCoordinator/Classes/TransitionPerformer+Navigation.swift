//
//  Coordinator+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UINavigationController {
    private func resetChildrenAnimations(holding: [Animation?]) {
        rootViewController.animationDelegate?.resetChildrenAnimations(for: rootViewController)
    }

    func push(_ viewController: UIViewController,
              with options: TransitionOptions,
              animation: Animation?,
              completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        self.rootViewController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        if let animation = animation {
            rootViewController.topViewController?.transitioningDelegate = animation
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        if toRoot {
            self.rootViewController.popToRootViewController(animated: options.animated)
        } else {
            self.rootViewController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }

    func set(_ viewControllers: [UIViewController],
             with options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            viewControllers.last?.transitioningDelegate = animation
        }
        resetChildrenAnimations(holding: [animation])
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let animation = animation {
                viewControllers.forEach { $0.transitioningDelegate = animation }
            }
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        self.rootViewController.setViewControllers(viewControllers, animated: options.animated)

        CATransaction.commit()
    }

    func pop(to viewController: UIViewController,
             options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            rootViewController.topViewController?.transitioningDelegate = animation
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        self.rootViewController.popToViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }
}
