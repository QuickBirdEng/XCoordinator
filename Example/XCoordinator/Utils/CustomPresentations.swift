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
        presentation: StaticTransitionAnimation.flipPresentation,
        dismissal: StaticTransitionAnimation.flipPresentation
    )

    static let interactiveFlip = Animation(
        presentation: InteractiveTransitionAnimation.flipPresentation,
        dismissal: InteractiveTransitionAnimation.flipPresentation
    )

    static let staticFade = Animation(
        presentation: StaticTransitionAnimation.fadePresentation,
        dismissal: StaticTransitionAnimation.fadePresentation
    )

    static let interactiveFade = Animation(
        presentation: InteractiveTransitionAnimation.fadePresentation,
        dismissal: InteractiveTransitionAnimation.fadePresentation
    )
}

extension StaticTransitionAnimation {
    static let fadePresentation = StaticTransitionAnimation(duration: defaultAnimationDuration, performAnimation: { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        toView.alpha = 0.0
        containerView.addSubview(toView)

        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            toView.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    })

    static let flipPresentation = StaticTransitionAnimation(duration: defaultAnimationDuration, performAnimation: { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        let snapshotView = toView.snapshotView(afterScreenUpdates: true)!

        UIView.transition(with: containerView, duration: defaultAnimationDuration, options: [.transitionFlipFromLeft], animations: {
            containerView.addSubview(snapshotView)
        }, completion: { _ in
            containerView.addSubview(toView)
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    })
}

extension InteractiveTransitionAnimation {
    static let fadePresentation = InteractiveTransitionAnimation(completionSpeed: 1, completionCurve: .easeInOut, wantsInteractiveStart: false, transitionAnimation: StaticTransitionAnimation.fadePresentation)
    static let flipPresentation = InteractiveTransitionAnimation(completionSpeed: 1, completionCurve: .easeInOut, wantsInteractiveStart: false, transitionAnimation: StaticTransitionAnimation.flipPresentation)
}
