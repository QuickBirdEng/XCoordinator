//
//  InterruptibleTransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.12.18.
//

import Foundation

///
/// Use InterruptibleTransitionAnimation to define interactive transitions based on the `UIViewPropertyAnimator` APIs
/// introduced in iOS 10.
///
@available(iOS 10.0, *)
open class InterruptibleTransitionAnimation: InteractiveTransitionAnimation {

    // MARK: - Stored properties

    private let _generateInterruptibleAnimator: (UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating

    private var _interruptibleAnimator: UIViewImplicitlyAnimating?

    // MARK: - Init

    ///
    /// Creates an interruptible transition animation based on duration, an animator generator closure
    /// and an interaction controller generator closure.
    ///
    /// - Parameter duration:
    ///     The total duration of the animation.
    ///
    /// - Parameter generateAnimator:
    ///     A generator closure to create a `UIViewPropertyAnimator` dynamically.
    ///
    /// - Parameter generateInteractionController:
    ///     A generator closure to create an interaction controller which handles animation progress changes.
    ///
    public init(duration: TimeInterval,
                generateAnimator: @escaping (UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating,
                generateInteractionController: @escaping () -> PercentDrivenInteractionController?) {
        self._generateInterruptibleAnimator = generateAnimator
        super.init(
            duration: duration,
            transition: { _ in },
            generateInteractionController: generateInteractionController
        )
    }

    ///
    /// Creates an interruptible transition animation based on duration and an animator generator closure.
    ///
    /// A `UIPercentDrivenInteractiveTransition` is used as interaction controller.
    ///
    /// - Parameter duration:
    ///     The total duration of the animation.
    ///
    /// - Parameter generateAnimator:
    ///     A generator closure to create a `UIViewPropertyAnimator` dynamically.
    ///
    public convenience init(duration: TimeInterval,
                            generateAnimator: @escaping (UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating) {
        self.init(
            duration: duration,
            generateAnimator: generateAnimator,
            generateInteractionController: InteractiveTransitionAnimation.generateDefaultInteractionController
        )
    }

    // MARK: - Methods

    ///
    /// Generates an interruptible animator based on the transitionContext.
    /// It further adds a completion block to the animator to ensure it is deallocated once
    /// the transition is finished.
    ///
    /// This code is called once per transition to generate the interruptible animator
    /// which is reused in subsequent calls of `interruptibeAnimator(using:)`.
    ///
    /// - Parameter transitionContext:
    ///     The context in which the transition is performed.
    ///
    open func generateInterruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let animator = _generateInterruptibleAnimator(transitionContext)
        animator.addCompletion? { [weak self] position in
            switch position {
            case .start, .end:
                self?._interruptibleAnimator = nil
            case .current:
                break
            }
        }
        _interruptibleAnimator = animator
        return animator
    }

    // MARK: - TransitionAnimation

    ///
    /// See UIKit documentation for further information.
    ///
    /// This method simply calls `startAnimation()` on the interruptible animator.
    ///
    /// - Parameter transitionContext:
    ///     The context in which the transition is performed.
    ///
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    ///
    /// See UIKit documentation for further information.
    ///
    /// This method returns an already generated interruptible animator, if present.
    /// Otherwise it generates a new one using `generateInterruptibleAnimator(using:)`.
    ///
    /// - Parameter transitionContext:
    ///     The context in which the transition is performed.
    ///
    open func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning
        ) -> UIViewImplicitlyAnimating {
        return _interruptibleAnimator ?? generateInterruptibleAnimator(using: transitionContext)
    }
}
