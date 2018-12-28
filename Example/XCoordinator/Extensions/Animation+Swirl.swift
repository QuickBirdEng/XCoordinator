//
//  Animation+Swirl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

@available(iOS 10.0, *)
extension Animation {
    static let swirl = Animation(
        presentation: InterruptibleTransitionAnimation.swirlPresentation,
        dismissal: InterruptibleTransitionAnimation.swirlDismissal
    )
}

@available(iOS 10.0, *)
extension InterruptibleTransitionAnimation {
    fileprivate static let swirlPresentation = InterruptibleTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        toView.transform = CGAffineTransform(scaleX: .verySmall, y: .verySmall)
        toView.alpha = 0

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        let animator = UIViewPropertyAnimator(duration: defaultAnimationDuration, curve: .easeInOut) {
            toView.transform = .identity
            toView.transform.rotate(by: .pi - .verySmall)
            toView.transform.rotate(by: .pi - .verySmall)

            toView.alpha = 1
            fromView.alpha = 0
        }

        animator.addCompletion { _ in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }

    fileprivate static let swirlDismissal = InterruptibleTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView: UIView = transitionContext.containerView
        let toView: UIView = transitionContext.view(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        toView.alpha = 0

        let animator = UIViewPropertyAnimator(duration: defaultAnimationDuration, curve: .easeInOut) {
            fromView.transform.scale(by: .verySmall)
            fromView.transform.rotate(by: -.pi + .verySmall)
            fromView.transform.rotate(by: -.pi + .verySmall)

            toView.alpha = 1
            fromView.alpha = 0
        }

        animator.addCompletion { _ in
            if !transitionContext.transitionWasCancelled {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}
