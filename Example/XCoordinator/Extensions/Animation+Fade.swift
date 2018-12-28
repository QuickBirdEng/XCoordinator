//
//  Animation+Fade.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

extension Animation {
    static let fade = Animation(
        presentation: InteractiveTransitionAnimation.fade,
        dismissal: InteractiveTransitionAnimation.fade
    )
}

extension InteractiveTransitionAnimation {
    fileprivate static let fade = InteractiveTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
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
}
