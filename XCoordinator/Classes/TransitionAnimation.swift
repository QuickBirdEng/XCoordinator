//
//  TransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

public protocol TransitionAnimation: UIViewControllerAnimatedTransitioning {
    var interactive: UIViewControllerInteractiveTransitioning? { get }
    var percentDrivenInteractive: UIPercentDrivenInteractiveTransition? { get }
}

extension TransitionAnimation where Self: UIViewControllerInteractiveTransitioning {
    public var interactive: UIViewControllerInteractiveTransitioning? {
        return self
    }
}

extension TransitionAnimation where Self: UIPercentDrivenInteractiveTransition {
    public var percentDrivenInteractive: UIPercentDrivenInteractiveTransition? {
        return self
    }
}
