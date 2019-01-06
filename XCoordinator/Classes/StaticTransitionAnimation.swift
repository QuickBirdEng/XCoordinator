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

    open var interactionController: PercentDrivenInteractionController? {
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

    ///
    /// See UIKit documentation for further information.
    ///
    /// - Parameter transitionContext:
    ///     The context of the current transition.
    ///
    /// - Returns:
    ///     The duration of the animation as specified in the initializer.
    ///
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    ///
    /// See UIKit documentation for further information.
    ///
    /// This method performs the animation as specified in the initializer.
    ///
    /// - Parameter transitionContext:
    ///     The context of the current transition.
    ///
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        _performAnimation(transitionContext)
    }

    // MARK: - TransitionAnimation

    open func start() {}
    open func cleanup() {}
}

extension StaticTransitionAnimation {

    ///
    /// This method performs the animation as specified in the initializer.
    ///
    /// - Parameter transitionContext:
    ///     The context of the current transition.
    ///
    @available(*, deprecated, renamed: "animateTransition(using:)")
    public func performTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        _performAnimation(transitionContext)
    }
}
