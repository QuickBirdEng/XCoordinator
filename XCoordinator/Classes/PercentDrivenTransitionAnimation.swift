//
//  PercentDrivenTransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension UIPercentDrivenInteractiveTransition: TransitionAnimation {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
    }
}
