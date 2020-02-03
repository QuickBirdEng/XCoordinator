//
//  NavigationAnimationDelegate.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// NavigationAnimationDelegate is used as the delegate of a NavigationCoordinator's rootViewController
/// to allow for push-transitions to specify animations.
///
/// NavigationAnimationDelegate conforms to the `UINavigationControllerDelegate` protocol
/// and is intended for use as the delegate of one navigation controller only.
///
/// - Note:
///     Do not override the delegate of a NavigationCoordinator's rootViewController.
///     Instead use the delegate property of the NavigationCoordinator itself.
///
open class NavigationAnimationDelegate: NSObject {

    // MARK: Static properties

    // swiftlint:disable:next identifier_name
    private static let interactivePopGestureRecognizerDelegateAction = Selector(("handleNavigationTransition:"))

    // MARK: Stored properties

    /// The velocity threshold needed for the interactive pop transition to succeed
    open var velocityThreshold: CGFloat { UIScreen.main.bounds.width / 2 }

    /// The transition progress threshold for the interactive pop transition to succeed
    open var transitionProgressThreshold: CGFloat { 0.5 }

    // swiftlint:disable:next weak_delegate
    private var interactivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    private var popAnimation: TransitionAnimation?

    // MARK: Weak properties

    internal weak var delegate: UINavigationControllerDelegate?
    internal weak var presentable: (Presentable & AnyObject)?
    private weak var navigationController: UINavigationController?

    // MARK: Helper methods

    private func currentPopAnimation() -> TransitionAnimation? {
        guard let topViewController = navigationController?.topViewController else { return nil }
        return topViewController.transitioningDelegate?
            .animationController?(forDismissed: topViewController) as? TransitionAnimation
    }

    @discardableResult
    private func resetPopAnimation() -> TransitionAnimation? {
        popAnimation = currentPopAnimation()
        return popAnimation
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationAnimationDelegate: UINavigationControllerDelegate {

    ///
    /// See [UINavigationControllerDelegate documentation](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
    /// for further reference.
    ///
    /// - Parameters:
    ///     - navigationController: The delegate owner.
    ///     - animationController: The animationController to return the interactionController for.
    ///
    /// - Returns:
    ///     If the animationController is a `TransitionAnimation`, it returns its interactionController.
    ///     Otherwise it requests an interactionController from the NavigationCoordinator's delegate.
    ///
    open func navigationController(_ navigationController: UINavigationController,
                                   interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    ///
    /// See [UINavigationControllerDelegate documentation](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
    /// for further reference.
    ///
    /// - Parameters:
    ///     - navigationController: The delegate owner.
    ///     - operation: The operation being executed. Possible values are push, pop or none.
    ///     - fromVC: The source view controller of the transition.
    ///     - toVC: The destination view controller of the transition.
    ///
    /// - Returns:
    ///     The destination view controller's animationController depending on its `transitioningDelegate`.
    ///     In the case of a `push` operation, it returns the toVC's presentation animation.
    ///     For `pop` it is the fromVC's dismissal animation. If there is no transitioningDelegate or the operation `none` is used,
    ///     it uses the NavigationCoordinator's delegate as fallback.
    ///
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
            @unknown default:
                return nil
            }
        }()
        return transitionAnimation
            ?? delegate?.navigationController?(navigationController,
                                               animationControllerFor: operation, from: fromVC, to: toVC)
    }

    ///
    /// See [UINavigationControllerDelegate documentation](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
    /// for further reference.
    ///
    /// - Parameters:
    ///     - navigationController: The delegate owner.
    ///     - operation: The operation being executed. Possible values are push, pop or none.
    ///     - viewController: The target view controller.
    ///
    open func navigationController(_ navigationController: UINavigationController,
                                   didShow viewController: UIViewController, animated: Bool) {
        setupPopGestureRecognizer(for: navigationController)
        presentable?.childTransitionCompleted()
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    ///
    /// See [UINavigationControllerDelegate documentation](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
    /// for further reference.
    ///
    /// - Parameters:
    ///     - navigationController: The delegate owner.
    ///     - operation: The operation being executed. Possible values are push, pop or none.
    ///     - viewController: The view controller to be shown.
    ///
    open func navigationController(_ navigationController: UINavigationController,
                                   willShow viewController: UIViewController,
                                   animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension NavigationAnimationDelegate: UIGestureRecognizerDelegate {

    // MARK: Delegate methods

    ///
    /// See [UIGestureRecognizerDelegate documentation](https://developer.apple.com/documentation/uikit/UIGestureRecognizerDelegate)
    /// for further reference.
    ///
    /// - Note:
    ///     This method alters the target of the gestureRecognizer to either its former delegate (UIKit default)
    ///     or this class depending on whether a pop animation has been specified.
    ///
    /// - Parameter gestureRecognizer:
    ///     The gesture recognizer this class is the delegate of.
    ///     This class is used as the delegate for the interactivePopGestureRecognizer of
    ///     the navigationController.
    ///
    /// - Returns:
    ///     This method returns true, if and only if
    ///     - there are more than 1 view controllers on the navigation controller stack (so that it is possible to pop a viewController) and
    ///     - it is the interactivePopGestureRecognizer to call this method
    ///
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer {
        case navigationController?.interactivePopGestureRecognizer:
            let delegateAction = NavigationAnimationDelegate.interactivePopGestureRecognizerDelegateAction

            guard let delegate = interactivePopGestureRecognizerDelegate,
                delegate.responds(to: delegateAction) else {
                    // swiftlint:disable:next line_length
                    assertionFailure("Please don't set a custom delegate on \(UINavigationController.self).\(#selector(getter: UINavigationController.interactivePopGestureRecognizer)).")
                    return false
            }

            gestureRecognizer.removeTarget(nil, action: nil)

            if resetPopAnimation() != nil {
                gestureRecognizer.addTarget(self, action: #selector(handleInteractivePopGestureRecognizer(_:)))
            } else {
                gestureRecognizer.addTarget(delegate, action: delegateAction)
            }
            return (navigationController?.viewControllers.count ?? 0) > 1
        default:
            return false
        }
    }

    // MARK: Target actions

    ///
    /// This method handles changes of the navigation controller's `interactivePopGestureRecognizer`.
    ///
    /// This method performs the top-most dismissalAnimation and informs its interaction controller about changes
    /// of the interactivePopGestureRecognizer's state.
    ///
    /// - Parameter gestureRecognizer: The interactivePopGestureRecognizer of the `UINavigationController`.
    ///
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
        @unknown default:
            return
        }
    }

    // MARK: Helpers

    ///
    /// This method sets up the `interactivePopGestureRecognizer` of the navigation controller
    /// to allow for custom interactive pop animations.
    ///
    /// This method overrides the delegate of the `interactivePopGestureRecognizer` to `self`,
    /// but keeps a reference to the original delegate to enable the default pop animations.
    ///
    /// - Parameter navigationController: The navigation controller to be set up.
    ///
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
        delegate as? NavigationAnimationDelegate
    }
}
