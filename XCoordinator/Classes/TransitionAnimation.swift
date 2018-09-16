//
//  TransitionAnimation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol TransitionAnimation: UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval { get }
    var performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void { get }
}

