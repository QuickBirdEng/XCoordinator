//
//  InteractiveTransitionAnimation.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public class InteractiveTransitionAnimation: NSObject, TransitionAnimation, UIViewControllerInteractiveTransitioning {

    // MARK: - Stored properties

    public let duration: TimeInterval
    public let completionSpeed: CGFloat
    public let completionCurve: UIViewAnimationCurve
    public let wantsInteractiveStart: Bool

    public let performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void
    private let startInteractiveTransition: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    // MARK: - Init

    public init(duration: TimeInterval,
         completionSpeed: CGFloat,
         completionCurve: UIViewAnimationCurve,
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

    // MARK: - Methods

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

