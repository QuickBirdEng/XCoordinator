//
//  Animation+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

class NavigationAnimationDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Stored properties

    private var animations = [Animation?]()
    weak var delegate: UINavigationControllerDelegate?

    // MARK: - Methods

    internal func resetChildrenAnimations(for navigationController: UINavigationController) {
        animations = navigationController.children.map { $0.transitioningDelegate as? Animation }
        assert(animations.count == navigationController.children.count)
    }

    // MARK: - UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationController as? UIViewControllerInteractiveTransitioning
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionAnimation: UIViewControllerAnimatedTransitioning? = {
            switch operation {
            case .push:
                guard let animation = toVC.transitioningDelegate as? Animation else {
                    return nil
                }
                animation.setup(for: toVC)
                return animation.presentationAnimation
            case .pop:
                guard let animation = fromVC.transitioningDelegate as? Animation else {
                    return nil
                }
                animation.setup(for: fromVC)
                return animation.dismissalAnimation
            case .none:
                assertionFailure()
                return nil
            }
        }()
        return transitionAnimation
            ?? delegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
}

extension UINavigationController {
    internal var animationDelegate: NavigationAnimationDelegate? {
        return delegate as? NavigationAnimationDelegate
    }
}
