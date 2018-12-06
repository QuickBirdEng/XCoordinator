//
//  TransitionAnimation.swift
//  XCoordinator
//
//  Created by Paul Kraft on 26.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

public protocol TransitionAnimation: UIViewControllerAnimatedTransitioning {
    var interactionController: PercentDrivenInteractionController? { get }

    func start()
    func cleanup()
}

public protocol PercentDrivenInteractionController: UIViewControllerInteractiveTransitioning {
    func update(_ percentComplete: CGFloat)
    func cancel()
    func finish()
}

extension UIPercentDrivenInteractiveTransition: PercentDrivenInteractionController {}
