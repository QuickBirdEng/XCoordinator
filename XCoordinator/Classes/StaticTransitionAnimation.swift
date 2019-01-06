//
//  StaticTransitionAnimation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// `StaticTransitionAnimation` is a class to realize static transition animations.
///
/// We advise against its use in favor of `InteractiveTransitionAnimation`, if possible, as it is as simple
/// to use. However, this class is helpful to make sure your transition animation is not mistaken to be
/// interactive, if your animation code does not fulfill the requirements of an interactive transition
/// animation.
///
open class StaticTransitionAnimation: NSObject, TransitionAnimation {

    // MARK: - Stored properties

    internal let duration: TimeInterval
    private let _performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    // MARK: - Computed properties

    public var interactionController: PercentDrivenInteractionController? {
        return self as? PercentDrivenInteractionController
    }

    // MARK: - Initialization

    ///
    /// Creates a StaticTransitionAnimation to be used as presentation or dismissal transition animation in
    /// an `Animation` object.
    ///
    /// - Parameter duration:
    ///     The total duration of the animation.
    ///
    /// - Parameter performAnimation:
    ///     Your animation code.
    ///
    /// - Parameter context:
    ///     From the context, you can access source and destination views and
    ///     viewControllers and the containerView.
    ///
    public init(duration: TimeInterval, performAnimation: @escaping (_ context: UIViewControllerContextTransitioning) -> Void) {
        self.duration = duration
        self._performAnimation = performAnimation
    }

    // MARK: - Methods

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        _performAnimation(transitionContext)
    }

    // MARK: - TransitionAnimation

    public func start() {}
    public func cleanup() {}
}

extension StaticTransitionAnimation {
    @available(*, deprecated, renamed: "animateTransition(using:)")
    public func performTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        _performAnimation(transitionContext)
    }
}
