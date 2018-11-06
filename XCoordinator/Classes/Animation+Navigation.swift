//
//  Animation+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

class NavigationAnimationDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Stored properties

    var animation: Animation?
    weak var delegate: UINavigationControllerDelegate?

    // MARK: - UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animation?.presentationAnimation as? UIViewControllerInteractiveTransitioning
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        func transitionAnimation() -> UIViewControllerAnimatedTransitioning? {
            switch operation {
            case .push:
                return animation?.presentationAnimation
            case .pop:
                return animation?.dismissalAnimation
            case .none:
                assertionFailure()
                return nil
            }
        }
        return transitionAnimation()
            ?? delegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return delegate?.navigationControllerSupportedInterfaceOrientations?(navigationController)
            ?? navigationController.visibleViewController?.supportedInterfaceOrientations
            ?? .all
    }

    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return delegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController)
            ?? navigationController.visibleViewController?.preferredInterfaceOrientationForPresentation
            ?? UIApplication.shared.statusBarOrientation
    }
}

extension UINavigationController {
    internal var animationDelegate: NavigationAnimationDelegate? {
        return delegate as? NavigationAnimationDelegate
    }

    public var coordinatorDelegate: UINavigationControllerDelegate? {
        get {
            return animationDelegate?.delegate
        }
        set {
            animationDelegate?.delegate = newValue
        }
    }
}
