//
//  Animation+Navigation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 16.09.18.
//

class NavigationControllerAnimationDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Stored properties

    var animation: Animation?
    weak var delegate: UINavigationControllerDelegate?

    // MARK: - Init

    override init() {
        print(NavigationControllerAnimationDelegate.self, #function)
        super.init()
    }

    deinit {
        print(NavigationControllerAnimationDelegate.self, #function)
    }

    // MARK: - UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animation?.presentationAnimation as? UIViewControllerInteractiveTransitioning
            ?? delegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return delegate?.navigationControllerSupportedInterfaceOrientations?(navigationController)
            ?? navigationController.visibleViewController?.supportedInterfaceOrientations
            ?? .all
    }

    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return delegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController)
            ?? navigationController.visibleViewController?.preferredInterfaceOrientationForPresentation
            ?? .unknown
    }
}

extension UINavigationController {
    internal var animationDelegate: NavigationControllerAnimationDelegate? {
        return delegate as? NavigationControllerAnimationDelegate
    }

    public var coordinatorDelegate: UINavigationControllerDelegate? {
        return animationDelegate?.delegate
    }
}
