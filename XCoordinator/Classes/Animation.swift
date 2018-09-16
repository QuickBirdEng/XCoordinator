//
//  Animation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class Animation: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Stored properties

    open let presentationAnimation: TransitionAnimation?
    open let dismissalAnimation: TransitionAnimation?

    // MARK: - Init

    public init(presentationAnimation: TransitionAnimation?, dismissalAnimation: TransitionAnimation?) {
        self.presentationAnimation = presentationAnimation
        self.dismissalAnimation = dismissalAnimation
    }

    // MARK: - Public methods

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimation
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentationAnimation as? UIViewControllerInteractiveTransitioning
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalAnimation as? UIViewControllerInteractiveTransitioning
    }

}
