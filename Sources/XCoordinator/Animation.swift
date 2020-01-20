//
//  Animation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// `Animation` is used to set presentation and dismissal animations for presentables.
///
/// Depending on the transition in use, different properties of a `UIViewController` are set to make sure the transition animation is used.
///
/// - Note:
///     To not override the previously set `Animation`, use `nil` when initializing a transition.
///
///     Make sure to hold a strong reference to the `Animation` object, as it is only held by a weak reference.
///
open class Animation: NSObject {

    // MARK: Static properties

    ///
    /// Use `Animation.default` to override currently set animations
    /// and reset to the default animations provided by iOS
    ///
    /// - Note:
    ///     To disable animations make sure to use non-animating `TransitionOptions` when triggering.
    ///
    public static let `default` = Animation(presentation: nil, dismissal: nil)

    // MARK: Stored properties

    /// The transition animation performed when transitioning to a presentable.
    open var presentationAnimation: TransitionAnimation?

    /// The transition animation performed when transitioning away from a presentable.
    open var dismissalAnimation: TransitionAnimation?

    // MARK: Initialization

    ///
    /// Creates an Animation object containing a presentation and a dismissal animation.
    ///
    /// - Parameters:
    ///     - presentation: The transition animation performed when transitioning to a presentable.
    ///     - dismissal: The transition animation performed when transitioning away from a presentable.
    ///
    public init(presentation: TransitionAnimation?, dismissal: TransitionAnimation?) {
        self.presentationAnimation = presentation
        self.dismissalAnimation = dismissal
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension Animation: UIViewControllerTransitioningDelegate {

    ///
    /// See [UIViewControllerTransitioningDelegate](https://developer.apple.com/documentation/uikit/UIViewControllerTransitioningDelegate)
    /// for further reference.
    ///
    /// - Parameters:
    ///     - presented: The view controller to be presented.
    ///     - presenting: The view controller that is presenting.
    ///     - source: The view controller whose `present(_:animated:completion:)` was called.
    ///
    /// - Returns:
    ///     The presentation animation when initializing the `Animation` object.
    ///
    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimation
    }

    ///
    /// See [UIViewControllerTransitioningDelegate](https://developer.apple.com/documentation/uikit/UIViewControllerTransitioningDelegate)
    /// for further reference.
    ///
    /// - Parameter dismissed:
    ///     The view controller to be dismissed.
    ///
    /// - Returns:
    ///     The dismissal animation when initializing the `Animation` object.
    ///
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissalAnimation
    }

    ///
    /// See [UIViewControllerTransitioningDelegate](https://developer.apple.com/documentation/uikit/UIViewControllerTransitioningDelegate)
    /// for further reference.
    ///
    /// - Parameter animator:
    ///     The animator of this transition, which is most likely the presentation animation.
    ///
    /// - Returns:
    ///     The presentation animation's interaction controller.
    ///
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        presentationAnimation?.interactionController
    }

    ///
    /// See [UIViewControllerTransitioningDelegate](https://developer.apple.com/documentation/uikit/UIViewControllerTransitioningDelegate)
    /// for further reference.
    ///
    /// - Parameter animator:
    ///     The animator of this transition, which is most likely the dismissal animation.
    ///
    /// - Returns:
    ///     The dismissal animation's interaction controller.
    ///
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        dismissalAnimation?.interactionController
    }

}
