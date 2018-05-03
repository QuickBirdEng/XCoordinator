//
//  StaticTransitionAnimation.swift
//  RxCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public class StaticTransitionAnimation: NSObject, TranistionAnimation {
    public let duration: TimeInterval
    public let performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    public init(duration: TimeInterval, performAnimation: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.duration = duration
        self.performAnimation = performAnimation
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        performAnimation(transitionContext)
    }
}

