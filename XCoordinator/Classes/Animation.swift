//
//  Animation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class Animation: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Static properties

    public static let `default` = Animation(presentation: nil, dismissal: nil)

    // MARK: - Stored properties

    public let presentationAnimation: TransitionAnimation?
    public let dismissalAnimation: TransitionAnimation?

    private weak var viewController: UIViewController? {
        didSet {
            oldValue?.navigationController?.interactivePopGestureRecognizer?.removeTarget(self, action: #selector(popGestureRecognizerChanged(_:)))
        }
    }
    open var velocityThreshold: CGFloat = 300
    open var transitionProgressThreshold: CGFloat = 0.5

    // MARK: - Init

    public init(presentation: TransitionAnimation?, dismissal: TransitionAnimation?) {
        self.presentationAnimation = presentation
        self.dismissalAnimation = dismissal
    }

    // MARK: - Public methods

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimation
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentationAnimation?.interactionController
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalAnimation?.interactionController
    }

    internal func setup(for viewController: UIViewController) {
        self.viewController = viewController
        if let navigationController = viewController.navigationController {
            navigationController.interactivePopGestureRecognizer?.addTarget(self, action: #selector(popGestureRecognizerChanged(_:)))
        }
    }

    @objc
    private func popGestureRecognizerChanged(_ recognizer: UIGestureRecognizer) {
        guard let viewController = self.viewController,
            let navigationController = viewController.navigationController,
            let recognizer = recognizer as? UIScreenEdgePanGestureRecognizer,
            let animation = dismissalAnimation?.percentDrivenTransition else {
                return
        }

        let viewTranslation = recognizer.translation(in: recognizer.view?.superview)
        let transitionProgress = viewTranslation.x / viewController.view.frame.width

        switch recognizer.state {
        case .began:
            navigationController.popViewController(animated: true)
        case .changed:
            animation.update(transitionProgress)
        case .cancelled:
            animation.cancel()
        case .ended:
            guard recognizer.velocity(in: recognizer.view).x < velocityThreshold else {
                animation.finish()
                return
            }
            if transitionProgress > transitionProgressThreshold {
                animation.finish()
            } else {
                animation.cancel()
            }
        default:
            return
        }
    }
}
