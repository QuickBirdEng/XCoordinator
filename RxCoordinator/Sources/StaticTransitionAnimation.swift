//
//  StaticTransitionAnimation.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public class StaticTransitionAnimation: NSObject, TranistionAnimation {

    // MARK: - Stored properties

    public let duration: TimeInterval
    public let performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    // MARK: - Init

    public init(duration: TimeInterval, performAnimation: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.duration = duration
        self.performAnimation = performAnimation
    }

    // MARK: - Methods

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        performAnimation(transitionContext)
    }
}

