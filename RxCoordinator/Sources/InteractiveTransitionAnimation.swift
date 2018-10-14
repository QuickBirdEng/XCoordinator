//
//  InteractiveTransitionAnimation.swift
//  RxCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public class InteractiveTransitionAnimation: NSObject, TransitionAnimation, UIViewControllerInteractiveTransitioning {
    public let duration: TimeInterval
    public let completionSpeed: CGFloat
    public let completionCurve: UIView.AnimationCurve
    public let wantsInteractiveStart: Bool

    public let performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void
    let startInteractiveTransition: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    public init(duration: TimeInterval,
         completionSpeed: CGFloat,
         completionCurve: UIView.AnimationCurve,
         wantsInteractiveStart: Bool,
         performAnimation: @escaping (UIViewControllerContextTransitioning) -> Void,
         startInteractiveTransition: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.duration = duration
        self.completionSpeed = completionSpeed
        self.completionCurve = completionCurve
        self.wantsInteractiveStart = wantsInteractiveStart
        self.performAnimation = performAnimation
        self.startInteractiveTransition = startInteractiveTransition
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        performAnimation(transitionContext)
    }

    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
    }

}

