//
//  InterruptibleTransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 24.12.18.
//

import Foundation

@available(iOS 10.0, *)
open class InterruptibleTransitionAnimation: InteractiveTransitionAnimation {

    // MARK: - Stored properties

    private let _generateInterruptibleAnimator: (UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating

    private var _interruptibleAnimator: UIViewImplicitlyAnimating?

    // MARK: - Init

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

    public convenience init(duration: TimeInterval,
                            generateAnimator: @escaping (UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating) {
        self.init(
            duration: duration,
            generateAnimator: generateAnimator,
            generateInteractionController: InteractiveTransitionAnimation.generateDefaultInteractionController
        )
    }

    // MARK: - Methods

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

    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    open func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
        ) -> UIViewImplicitlyAnimating {
        return _interruptibleAnimator ?? generateInterruptibleAnimator(using: transitionContext)
    }
}
