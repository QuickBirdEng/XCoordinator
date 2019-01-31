//
//  Coordinator+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension UINavigationController {
    private func resetChildrenAnimations(holding: [Animation?]) {
        animationDelegate?.resetChildrenAnimations(for: self)
    }

    func push(_ viewController: UIViewController,
              with options: TransitionOptions,
              animation: Animation?,
              completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        if let animation = animation {
            topViewController?.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        if toRoot {
            popToRootViewController(animated: options.animated)
        } else {
            popViewController(animated: options.animated)
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
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let animation = animation {
                viewControllers.forEach { $0.transitioningDelegate = animation }
            }
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        setViewControllers(viewControllers, animated: options.animated)

        CATransaction.commit()
    }

    func pop(to viewController: UIViewController,
             options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            topViewController?.transitioningDelegate = animation
            viewController.transitioningDelegate = animation
        }

        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if your rootViewController's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if you did not call super.generateRootViewController to generate your rootViewController,
        or you set another delegate on your rootViewController. To set another delegate of your rootViewController, have a look
        at `NavigationCoordinator.delegate`.
        """)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.resetChildrenAnimations(holding: [animation])
            completion?()
        }

        popToViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }
}
