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
    public let completionCurve: UIView.AnimationCurve
    public let wantsInteractiveStart: Bool

    private let startInteractiveTransition: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    // MARK: - Computed properties

    public var interactive: UIViewControllerInteractiveTransitioning? {
        return self
    }

    public var percentDrivenInteractive: UIPercentDrivenInteractiveTransition? {
        return nil
    }

    // MARK: - Init

    public init(duration: TimeInterval,
                completionSpeed: CGFloat,
                completionCurve: UIView.AnimationCurve,
                wantsInteractiveStart: Bool,
                transition: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.duration = duration
        self.completionSpeed = completionSpeed
        self.completionCurve = completionCurve
        self.wantsInteractiveStart = wantsInteractiveStart
        self.startInteractiveTransition = transition
    }

    public convenience init(completionSpeed: CGFloat = 1, completionCurve: UIView.AnimationCurve = .easeInOut, wantsInteractiveStart: Bool = true, transitionAnimation: StaticTransitionAnimation) {
        self.init(
            duration: transitionAnimation.duration,
            completionSpeed: completionSpeed,
            completionCurve: completionCurve,
            wantsInteractiveStart: wantsInteractiveStart,
            transition: transitionAnimation.performAnimation
        )
    }

    // MARK: - Methods

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
    }

    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
    }

}
