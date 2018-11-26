//
//  TransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

public protocol TransitionAnimation: UIViewControllerAnimatedTransitioning {
    var interactionController: UIViewControllerInteractiveTransitioning? { get }
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition? { get }
}

extension TransitionAnimation where Self: UIViewControllerInteractiveTransitioning {
    public var interactionController: UIViewControllerInteractiveTransitioning? {
        return self
    }
}

extension TransitionAnimation where Self: UIPercentDrivenInteractiveTransition {
    public var percentDrivenTransition: UIPercentDrivenInteractiveTransition? {
        return self
    }
}
