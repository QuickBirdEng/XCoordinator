//
//  CustomPresentations.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//


import UIKit
import XCoordinator

private let defaultAnimationDuration: TimeInterval = 0.35

extension Animation {
    static let staticFlip = Animation(
        presentation: StaticTransitionAnimation.flip,
        dismissal: StaticTransitionAnimation.flip
    )


    static let interactiveFlip = Animation(
        presentation: InteractiveTransitionAnimation.flip,
        dismissal: InteractiveTransitionAnimation.flip
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
    static let fade = StaticTransitionAnimation(duration: defaultAnimationDuration, performAnimation: { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        toView.alpha = 0.0
        containerView.addSubview(toView)

        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            toView.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    })

    static let flip = StaticTransitionAnimation(duration: defaultAnimationDuration, performAnimation: { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        let snapshotView = toView.snapshotView(afterScreenUpdates: true)!

        UIView.transition(with: containerView, duration: defaultAnimationDuration, options: [.transitionFlipFromLeft], animations: {
            containerView.addSubview(snapshotView)
        }, completion: { _ in
            containerView.addSubview(toView)
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    })
}

extension InteractiveTransitionAnimation {
    static let fade = InteractiveTransitionAnimation(transitionAnimation: StaticTransitionAnimation.fade)
    static var flip = InteractiveTransitionAnimation(transitionAnimation: StaticTransitionAnimation.flip)
}
