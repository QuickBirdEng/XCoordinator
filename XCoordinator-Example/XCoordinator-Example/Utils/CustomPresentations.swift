//
//  CustomPresentations.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//


import UIKit
import XCoordinator

struct CustomPresentations {

    private static let defaultAnimationDuration = 0.5

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

    static let flippingPresentation = StaticTransitionAnimation(duration: defaultAnimationDuration, performAnimation: { transitionContext in
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
