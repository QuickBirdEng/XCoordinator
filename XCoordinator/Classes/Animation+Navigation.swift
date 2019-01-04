//
//  Animation+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// NavigationAnimationDelegate is used as the delegate of a NavigationCoordinator's rootViewController
/// to allow for push-transitions to specify animations.
///
/// This delegate is intended for use on one navigation controller only.
/// Do not use one object as delegate of multiple navigation controllers.
///
/// - Note:
///     Do not override the delegate of a NavigationCoordinator's rootViewController-delegate.
///     Instead use the delegate property of the NavigationCoordinator itself.
///
open class NavigationAnimationDelegate: NSObject {

    // MARK: - Static properties

    // swiftlint:disable:next identifier_name
    private static let interactivePopGestureRecognizerDelegateAction = Selector(("handleNavigationTransition:"))

    // MARK: - Stored properties

    /// Describes the velocity threshold needed for the interactive pop transition to succeed.
    open var velocityThreshold: CGFloat { return UIScreen.main.bounds.width / 2 }

    /// Describes the transition progress threshold for the interactive pop transition to succeed.
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

// MARK: - UINavigationControllerDelegate

extension NavigationAnimationDelegate: UINavigationControllerDelegate {

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter navigationController:
    ///     The navigation controller to which this object is the delegate of.
    ///
    /// - Parameter animationController:
    ///     The animationController to return the interactionController for.
    ///
    /// - Returns:
    ///     The interactionController of an animationController of type `TransitionAnimation`.
    ///     Otherwise the result of the NavigationCoordinator's delegate.
    ///
    open func navigationController(_ navigationController: UINavigationController,
                                   interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        return (animationController as? TransitionAnimation)?.interactionController
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter navigationController:
    ///     The navigation controller to which this object is the delegate of.
    ///
    /// - Parameter operation:
    ///     The operation being executed. Possible values are push, pop or none.
    ///
    /// - Parameter fromVC:
    ///     The source view controller of the transition.
    ///
    /// - Parameter toVC:
    ///     The destination view controller of the transition.
    ///
    /// - Returns:
    ///     The presentation animation of the last specified `Animation` object.
    ///     If not present, it uses the NavigationCoordinator's delegate as fallback.
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
            }
        }()
        return transitionAnimation
            ?? delegate?.navigationController?(navigationController,
                                               animationControllerFor: operation, from: fromVC, to: toVC)
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter navigationController:
    ///     The navigation controller to which this object is the delegate of.
    ///
    /// - Parameter operation:
    ///     The operation being executed. Possible values are push, pop or none.
    ///
    /// - Parameter viewController:
    ///     The shown view controller.
    ///
    open func navigationController(_ navigationController: UINavigationController,
                                   didShow viewController: UIViewController, animated: Bool) {
        setupPopGestureRecognizer(for: navigationController)
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter navigationController:
    ///     The navigation controller to which this object is the delegate of.
    ///
    /// - Parameter operation:
    ///     The operation being executed. Possible values are push, pop or none.
    ///
    /// - Parameter viewController:
    ///     The view controller to be shown.
    ///
    open func navigationController(_ navigationController: UINavigationController,
                                   willShow viewController: UIViewController,
                                   animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension NavigationAnimationDelegate: UIGestureRecognizerDelegate {

    // MARK: - Delegate methods

    ///
    /// See UIKit documentation for further reference.
    ///
    /// This method returns true, if
    /// - there are more than 1 view controllers in the navigation controller
    /// - it is the interactivePopGestureRecognizer to call this method
    ///
    /// It further alters the target of the gestureRecognizer to either its former delegate (UIKit default)
    /// or this class depending on whether a pop animation has been specified.
    ///
    /// - Parameter gestureRecognizer:
    ///     The gesture recognizer this class is the delegate of.
    ///     This class is used as the delegate for the interactivePopGestureRecognizer of
    ///     the navigationController.
    ///
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

    ///
    /// This method handles changes of the interactivePopGestureRecognizer of the navigation controller.
    ///
    /// In general this method updates the interaction controller of the top-most dismissalAnimation
    /// about the state of the interactivePopGestureRecognizer.
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
        }
    }

    // MARK: - Helpers

    ///
    /// This method sets up the `interactivePopGestureRecognizer` of the navigation controller to work as expected.
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
        return delegate as? NavigationAnimationDelegate
    }
}
