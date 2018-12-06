//
//  Animation+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class NavigationAnimationDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Static properties

    private static let interactivePopGestureRecognizerDelegateAction = Selector(("handleNavigationTransition:"))

    // MARK: - Stored properties

    open var velocityThreshold: CGFloat { return UIScreen.main.bounds.width / 2 }
    open private(set) var transitionProgressThreshold: CGFloat = 0.5

    private var animations = [Animation?]()

    // MARK: - Weak properties

    internal weak var delegate: UINavigationControllerDelegate?
    private weak var navigationController: UINavigationController?
    private weak var interactivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    // MARK: - Computed properties

    private var popAnimation: TransitionAnimation? {
        return animations.last??.dismissalAnimation
    }

    // MARK: - Methods

    internal func resetChildrenAnimations(for navigationController: UINavigationController) {
        animations = navigationController.children.map { $0.transitioningDelegate as? Animation }
        assert(animations.count == navigationController.children.count)
    }

    // MARK: - UINavigationControllerDelegate

    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionAnimation = { () -> UIViewControllerAnimatedTransitioning? in
            switch operation {
            case .push:
                setupPopGestureRecognizer(for: navigationController)
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
            ?? delegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }

    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

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

extension NavigationAnimationDelegate: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer {
        case navigationController?.interactivePopGestureRecognizer:
            if popAnimation != nil {
                gestureRecognizer.removeTarget(nil, action: nil)
                gestureRecognizer.addTarget(self, action: #selector(handleInteractivePopGestureRecognizer(_:)))
            } else {
                let action = NavigationAnimationDelegate.interactivePopGestureRecognizerDelegateAction
                guard let delegate = interactivePopGestureRecognizerDelegate,
                    delegate.responds(to: action) else {
                        assertionFailure("Please don't set your own delegate on \(String(describing: UINavigationController.self)).\(#selector(getter: UINavigationController.interactivePopGestureRecognizer)).")
                        return false
                }
                gestureRecognizer.removeTarget(nil, action: nil)
                gestureRecognizer.addTarget(delegate, action: action)
            }
            return true
        default:
            return false
        }
    }

    open func cleanup(cancelled: Bool) {
        popAnimation?.cleanup()
        if !cancelled {
            let popRecognizer = navigationController?.interactivePopGestureRecognizer
            popRecognizer?.delegate = interactivePopGestureRecognizerDelegate
            popRecognizer?.removeTarget(self, action: nil)
        }
    }

    @objc
    open func handleInteractivePopGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        guard let viewController = self.navigationController?.topViewController,
            let recognizer = gestureRecognizer as? UIPanGestureRecognizer else {
                return
        }

        let viewTranslation = recognizer.translation(in: recognizer.view?.superview)
        let transitionProgress = min(max(viewTranslation.x / viewController.view.frame.width, 0), 1)

        switch recognizer.state {
        case .possible, .failed:
            break
        case .began:
            if gestureRecognizer.view == viewController.navigationController?.view {
                popAnimation?.start()
            }
            navigationController?.popViewController(animated: true)
        case .changed:
            popAnimation?.interactionController?.update(transitionProgress)
        case .cancelled:
            defer { cleanup(cancelled: true) }
            popAnimation?.interactionController?.cancel()
        case .ended:
            let exceedsVelocityThreshold = recognizer.velocity(in: recognizer.view).x > velocityThreshold
            let exceedsProgressThreshold = transitionProgress > transitionProgressThreshold
            let finish = exceedsVelocityThreshold || exceedsProgressThreshold
            defer { cleanup(cancelled: !finish) }
            if finish {
                popAnimation?.interactionController?.finish()
            } else {
                popAnimation?.interactionController?.cancel()
            }
        }
    }
}


extension UINavigationController {
    internal var animationDelegate: NavigationAnimationDelegate? {
        return delegate as? NavigationAnimationDelegate
    }
}
