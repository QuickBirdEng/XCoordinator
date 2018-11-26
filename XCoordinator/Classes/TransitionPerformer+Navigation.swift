//
//  Coordinator+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UINavigationController {
    func push(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        rootViewController.animationDelegate?.animations.append(animation)
        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            assert(self.rootViewController.animationDelegate?.animations.count == self.rootViewController.children.count)
            completion?()
        }

        self.rootViewController.pushViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        if let animation = animation {
            rootViewController.topViewController?.transitioningDelegate = animation
        }
        rootViewController.animationDelegate?.animations.append(animation)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if toRoot {
                guard let animationDelegate = self.rootViewController.animationDelegate else {
                    return
                }
                animationDelegate.animations.removeLast(animationDelegate.animations.count - 1)
            } else {
                self.rootViewController.animationDelegate?.animations.removeLast(2)
            }
            assert(self.rootViewController.animationDelegate?.animations.count == self.rootViewController.children.count)
            completion?()
        }

        if toRoot {
            self.rootViewController.popToRootViewController(animated: options.animated)
        } else {
            self.rootViewController.popViewController(animated: options.animated)
        }

        CATransaction.commit()
    }

    func set(_ viewControllers: [UIViewController], with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.rootViewController.animationDelegate?.animations = viewControllers.map { _ in animation }
                assert(self.rootViewController.animationDelegate?.animations.count == self.rootViewController.children.count)
                completion?()
            }

            self.rootViewController.setViewControllers(viewControllers, animated: options.animated)

            CATransaction.commit()
        }

        if let animation = animation {
            viewControllers.last?.transitioningDelegate = animation
        }
        rootViewController.animationDelegate?.animations = [animation]
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }

    func pop(to viewController: UIViewController, options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {
        guard let viewControllerIndex = rootViewController.viewControllers.firstIndex(of: viewController) else {
            return assertionFailure()
        }

        let remainingCount = self.rootViewController.viewControllers.count - viewControllerIndex
        rootViewController.animationDelegate?.animations.removeLast(remainingCount - 1)
        rootViewController.animationDelegate?.animations.append(animation)
        if let animation = animation {
            rootViewController.topViewController?.transitioningDelegate = animation
            viewController.transitioningDelegate = animation
        }
        assert(self.rootViewController.animationDelegate?.animations.count == self.rootViewController.children.count)
        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.rootViewController.animationDelegate?.animations.removeLast()
            assert(self.rootViewController.animationDelegate?.animations.count == self.rootViewController.children.count)
            completion?()
        }

        self.rootViewController.popToViewController(viewController, animated: options.animated)

        CATransaction.commit()
    }
}
