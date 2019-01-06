//
//  TransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

///
/// TransitionAnimation aims to provide a common protocol for any type of transition animation used in an `Animation` object.
///
/// XCoordinator provides different implementations of this protocol with the `StaticTransitionAnimation`,
/// `InteractiveTransitionAnimation` and `InterruptibleTransitionAnimation` classes.
///
public protocol TransitionAnimation: UIViewControllerAnimatedTransitioning {

    ///
    /// The interaction controller of an animation.
    /// It gets notified about the state of an animation and handles the specific events accordingly.
    ///
    /// The interaction controller is reset when calling `TransitionAnimation.start()` can always be `nil`,
    /// e.g. in static transition animations.
    ///
    /// Until `TransitionAnimation.cleanup()` is called, it should always return the same instance.
    ///
    var interactionController: PercentDrivenInteractionController? { get }

    /// Starts the animation by possibly creating a new interaction controller.
    func start()

    /// Cleans up any remaining information after an animation has been completed, e.g. by deleting an interaction controller.
    func cleanup()
}

///
/// PercentDrivenInteractionController is used for interaction controller types that can updated based on a percentage of completion.
/// Furthermore, a PercentDrivenInteractionController should be able to cancel and finish a transition animation.
///
/// PercentDrivenInteractionController is based on the `UIViewControllerInteractiveTransitioning` protocol.
///
/// - Note:
///     While you can implement your custom implementation,
///     UIKit offers a default implementation with `UIPercentDrivenInteractiveTransition`.
///
public protocol PercentDrivenInteractionController: UIViewControllerInteractiveTransitioning {

    ///
    /// Updates the animation to be at the specified progress.
    ///
    /// This method is called based on user interactions.
    /// A linear progression of the animation is encouraged when handling user interactions.
    ///
    func update(_ percentComplete: CGFloat)

    ///
    /// Cancels the animation, e.g. by cleaning up and reversing any progress made.
    ///
    func cancel()

    ///
    /// Finishes the animation by completing it from the current progress onwards.
    ///
    func finish()
}

extension UIPercentDrivenInteractiveTransition: PercentDrivenInteractionController {}
