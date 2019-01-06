//
//  Animation+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class NavigationAnimationDelegate: NSObject {

    // MARK: - Static properties

    // swiftlint:disable:next identifier_name
    private static let interactivePopGestureRecognizerDelegateAction = Selector(("handleNavigationTransition:"))

    // MARK: - Stored properties

    open var velocityThreshold: CGFloat { return UIScreen.main.bounds.width / 2 }
    open var transitionProgressThreshold: CGFloat { return 0.5 }

    private var animations = [Animation?]()

    // swiftlint:disable:next weak_delegate
    private var interactivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    // MARK: - Weak properties

    internal weak var delegate: UINavigationControllerDelegate?
    private weak var navigationController: UINavigationController?

    // MARK: - Computed properties

    private var popAnimation: TransitionAnimation? {
        return animations.last??.dismissalAnimation
    }

    // MARK: - Methods

    internal func resetChildrenAnimations(for navigationController: UINavigationController) {
        animations = navigationController.children.map { $0.transitioningDelegate as? Animation }
        assert(animations.count == navigationController.children.count)
    }
}

// MARK: - NavigationAnimationDelegate: UINavigationControllerDelegate

extension NavigationAnimationDelegate: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController,
                                   interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        return (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionAnimation = { () -> UIViewControllerAnimatedTransitioning? in
            switch operation {
            case .push:
                return toVC.transitioningDelegate?
                    .animationController?(forPresented: toVC, presenting: navigationController, source: fromVC)
            case .pop:
                return fromVC.transitioningDelegate?
                    .animationController?(forDismissed: fromVC)
            case .none:
                return nil
            }
        }()
        return transitionAnimation
            ?? delegate?.navigationController?(navigationController,
                                               animationControllerFor: operation, from: fromVC, to: toVC)
    }

    open func navigationController(_ navigationController: UINavigationController,
                                   didShow viewController: UIViewController, animated: Bool) {
        setupPopGestureRecognizer(for: navigationController)
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    open func navigationController(_ navigationController: UINavigationController,
                                   willShow viewController: UIViewController,
                                   animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
}

// MARK: - NavigationAnimationDelegate: UIGestureRecognizerDelegate

extension NavigationAnimationDelegate: UIGestureRecognizerDelegate {

    // MARK: - Delegate methods

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer {
        case navigationController?.interactivePopGestureRecognizer:
            let delegateAction = NavigationAnimationDelegate.interactivePopGestureRecognizerDelegateAction

            guard let delegate = interactivePopGestureRecognizerDelegate,
                delegate.responds(to: delegateAction) else {
                    // swiftlint:disable:next line_length
                    assertionFailure("Please don't set your own delegate on \(String(describing: UINavigationController.self)).\(#selector(getter: UINavigationController.interactivePopGestureRecognizer)).")
                    return false
            }

            gestureRecognizer.removeTarget(nil, action: nil)

            if popAnimation != nil {
                gestureRecognizer.addTarget(self, action: #selector(handleInteractivePopGestureRecognizer(_:)))
            } else {
                gestureRecognizer.addTarget(delegate, action: delegateAction)
            }
            return (navigationController?.viewControllers.count ?? 0) > 1
        default:
            return false
        }
    }

    // MARK: - Target actions

    @objc
    open func handleInteractivePopGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        guard let viewController = self.navigationController?.topViewController,
            let recognizer = gestureRecognizer as? UIPanGestureRecognizer else {
                return
        }

        let viewTranslation = recognizer.translation(in: recognizer.view?.superview)
        let transitionProgress = min(max(viewTranslation.x / viewController.view.frame.width, 0), 1)
        let interactionController = popAnimation?.interactionController

        switch recognizer.state {
        case .possible, .failed:
            break
        case .began:
            if gestureRecognizer.view == viewController.navigationController?.view {
                popAnimation?.start()
            }
            navigationController?.popViewController(animated: true)
        case .changed:
            interactionController?.update(transitionProgress)
        case .cancelled:
            defer { popAnimation?.cleanup() }
            interactionController?.cancel()
        case .ended:
            defer { popAnimation?.cleanup() }
            if recognizer.velocity(in: recognizer.view).x > velocityThreshold
                || transitionProgress > transitionProgressThreshold {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
        }
    }

    // MARK: - Helpers

    open func setupPopGestureRecognizer(for navigationController: UINavigationController) {
        self.navigationController = navigationController
        guard let popRecognizer = navigationController.interactivePopGestureRecognizer,
            popRecognizer.delegate !== self else {
                return
        }
        interactivePopGestureRecognizerDelegate = popRecognizer.delegate
        popRecognizer.delegate = self
    }
}

extension UINavigationController {
    internal var animationDelegate: NavigationAnimationDelegate? {
        return delegate as? NavigationAnimationDelegate
    }
}
