//
//  Animation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class Animation: NSObject {

    // MARK: - Static properties

    /// `Animation.default` can be used to reset animations of a `Presentables`.
    /// If not otherwise specified, the usual UIKit-animations will be used.
    public static let `default` = Animation(presentation: nil, dismissal: nil)

    // MARK: - Stored properties

    open var presentationAnimation: TransitionAnimation?
    open var dismissalAnimation: TransitionAnimation?

    // MARK: - Init

    ///
    /// Creates an `Animation` object to reflect possible animations of a `Presentable`.
    ///
    /// - Parameter presentation: specifies a `TransitionAnimation` used when displaying a new `Presentable`.
    ///
    /// - Parameter dismissal: specifies a `TransitionAnimation` used when dismissing a `Presentable`.
    ///
    public init(presentation: TransitionAnimation?, dismissal: TransitionAnimation?) {
        self.presentationAnimation = presentation
        self.dismissalAnimation = dismissal
    }
}

// MARK: - Animation: UIViewControllerTransitioningDelegate

extension Animation: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimation
    }

    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentationAnimation?.interactionController
    }

    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalAnimation?.interactionController
    }
}
