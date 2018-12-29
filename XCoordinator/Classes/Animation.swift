//
//  Animation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// Use `Animation` to set presentation and dismissal animations for presentables.
///
/// Depending on the transition in use, we set different properties of a `UIViewController` to make sure the transition animation is used.
///
/// - Note:
///
/// To not override the previously set `Animation`, use `nil` when initializing a transition.
///
/// Make sure to hold a strong reference to the `Animation` object,
/// as XCoordinator does not ensure to hold the `Animation` strongly by itself.
///
open class Animation: NSObject {

    // MARK: - Static properties

    ///
    /// Use `Animation.default` to override currently set animations
    /// and reset to the default animations provided by iOS
    ///
    /// To disable animations make sure to use non-animating `TransitionOptions` when triggering.
    ///
    public static let `default` = Animation(presentation: nil, dismissal: nil)

    // MARK: - Stored properties

    /// The transition animation shown when transitioning to a presentable.
    open var presentationAnimation: TransitionAnimation?

    /// The transition animation shown when transitioning away from a presentable.
    open var dismissalAnimation: TransitionAnimation?

    // MARK: - Init

    ///
    /// - Parameter presentation: The transition animation shown when transitioning to a presentable.
    ///
    /// - Parameter dismissal: The transition animation shown when transitioning away from a presentable.
    ///
    public init(presentation: TransitionAnimation?, dismissal: TransitionAnimation?) {
        self.presentationAnimation = presentation
        self.dismissalAnimation = dismissal
    }
}

// MARK: - Animation: UIViewControllerTransitioningDelegate

extension Animation: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimation
    }

    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        return presentationAnimation?.interactionController
    }

    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        return dismissalAnimation?.interactionController
    }
}
