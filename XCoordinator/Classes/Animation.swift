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
///     To not override the previously set `Animation`, use `nil` when initializing a transition.
///
///     Make sure to hold a strong reference to the `Animation` object, as XCoordinator does not ensure
///     to hold the `Animation` strongly by itself.
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

    // MARK: - Initialization

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

// MARK: - UIViewControllerTransitioningDelegate

extension Animation: UIViewControllerTransitioningDelegate {

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter presented:
    ///     The view controller to be presented.
    ///
    /// - Parameter presenting:
    ///     The view controller to present.
    ///
    /// - Parameter source:
    ///     The view controller `present(_:animated:completion:)` was called on.
    ///
    /// - Returns:
    ///     The specified presentation animation.
    ///
    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter dismissed:
    ///     The view controller to be dismissed.
    ///
    /// - Returns:
    ///     The specified dismissal animation.
    ///
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimation
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter animator:
    ///     The presentation animation.
    ///
    /// - Returns:
    ///     The presentation animation's interaction controller.
    ///
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        return presentationAnimation?.interactionController
    }

    ///
    /// See UIKit documentation for further reference.
    ///
    /// - Parameter animator:
    ///     The dismissal animation.
    ///
    /// - Returns:
    ///     The dismissal animation's interaction controller.
    ///
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        return dismissalAnimation?.interactionController
    }
}
