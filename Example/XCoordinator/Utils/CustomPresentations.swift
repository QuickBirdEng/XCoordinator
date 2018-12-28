//
//  CustomPresentations.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//


import UIKit
import XCoordinator

private let defaultAnimationDuration: TimeInterval = 0.35

extension Animation {
    static let staticScale = Animation(
        presentation: StaticTransitionAnimation.scalePresentation,
        dismissal: StaticTransitionAnimation.scaleDismissal
    )

    @available(iOS 10.0, *)
    static let interruptibleSwirl = Animation(
        presentation: InterruptibleTransitionAnimation.swirlPresentation,
        dismissal: InterruptibleTransitionAnimation.swirlDismissal
    )

    static let interactiveScale = Animation(
        presentation: InteractiveTransitionAnimation.scalePresentation,
        dismissal: InteractiveTransitionAnimation.scaleDismissal
    )

    static let staticFade = Animation(
        presentation: StaticTransitionAnimation.fade,
        dismissal: StaticTransitionAnimation.fade
    )

    static let interactiveFade = Animation(
        presentation: InteractiveTransitionAnimation.fade,
        dismissal: InteractiveTransitionAnimation.fade
    )
}

extension StaticTransitionAnimation {

    static let verySmall: CGFloat = 0.0001

    static let fade = StaticTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        toView.alpha = 0.0
        containerView.addSubview(toView)

        UIView.animate(withDuration: defaultAnimationDuration, delay: 0, options: [.curveLinear], animations: {
            toView.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    static let scalePresentation = StaticTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        toView.transform = CGAffineTransform(scaleX: verySmall, y: verySmall)
        toView.alpha = 0

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            toView.transform = .identity
            toView.transform.rotate(by: .pi)
            toView.transform.rotate(by: .pi)

            toView.alpha = 1
            fromView.alpha = 0
        }, completion: { _ in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    static let scaleDismissal = StaticTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView: UIView = transitionContext.containerView
        let toView: UIView = transitionContext.view(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        toView.alpha = 0
        fromView.layer.masksToBounds = true
        let cornerRadius = max(fromView.frame.height, fromView.frame.width)

        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            fromView.transform.scale(by: verySmall)
            fromView.transform.rotate(by: -.pi + verySmall)
            fromView.transform.rotate(by: -.pi + verySmall)

            toView.alpha = 1
            fromView.alpha = 0
        }, completion: { _ in
            if !transitionContext.transitionWasCancelled {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    static let swirlPresentation = StaticTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        toView.transform = CGAffineTransform(scaleX: verySmall, y: verySmall)
        toView.alpha = 0

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            toView.transform = .identity
            toView.transform.rotate(by: .pi)
            toView.transform.rotate(by: .pi)

            toView.alpha = 1
            fromView.alpha = 0
        }, completion: { _ in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    static let swirlDismissal = StaticTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView: UIView = transitionContext.containerView
        let toView: UIView = transitionContext.view(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        toView.alpha = 0

        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            fromView.transform.scale(by: verySmall)
            fromView.transform.rotate(by: -.pi + verySmall)
            fromView.transform.rotate(by: -.pi + verySmall)

            toView.alpha = 1
            fromView.alpha = 0
        }, completion: { _ in
            if !transitionContext.transitionWasCancelled {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension InteractiveTransitionAnimation {
    static let fade = InteractiveTransitionAnimation(transitionAnimation: StaticTransitionAnimation.fade)
    static let scalePresentation = InteractiveTransitionAnimation(transitionAnimation: StaticTransitionAnimation.scalePresentation)
    static let scaleDismissal = InteractiveTransitionAnimation(transitionAnimation: StaticTransitionAnimation.scaleDismissal)
}

extension CGAffineTransform {
    mutating func rotate(by rotationAngle: CGFloat) {
        self = self.rotated(by: rotationAngle)
    }

    mutating func scale(by scalingFactor: CGFloat) {
        self = self.scaledBy(x: scalingFactor, y: scalingFactor)
    }
}

@available(iOS 10.0, *)
extension InterruptibleTransitionAnimation {
    static let verySmall: CGFloat = 0.0001

    static let swirlPresentation = InterruptibleTransitionAnimation(duration: 0.35) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        toView.transform = CGAffineTransform(scaleX: verySmall, y: verySmall)
        toView.alpha = 0

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        let animator = UIViewPropertyAnimator(duration: 0.35, curve: .linear) {
            toView.transform = .identity
            toView.transform.rotate(by: .pi)
            toView.transform.rotate(by: .pi)

            toView.alpha = 1
            fromView.alpha = 0
        }

        animator.addCompletion { _ in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }

    static let swirlDismissal = InterruptibleTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView: UIView = transitionContext.containerView
        let toView: UIView = transitionContext.view(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        toView.alpha = 0

        let animator = UIViewPropertyAnimator(duration: 0.35, curve: .linear) {
            fromView.transform.scale(by: verySmall)
            fromView.transform.rotate(by: -.pi + verySmall)
            fromView.transform.rotate(by: -.pi + verySmall)

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
