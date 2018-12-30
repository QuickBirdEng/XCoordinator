//
//  InteractiveTransitionAnimation.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// `InteractiveTransitionAnimation` provides a simple interface to create interactive transition animations.
///
/// You can simply create an `InteractiveTransitionAnimation` by providing the duration, the animation code
/// and (optionally) a closure to create an interaction controller.
///
/// - Note:
///     To get further information read the UIKit documentation of `UIViewControllerAnimatedTransitioning`,
///     `UIViewControllerInteractiveTransitioning`, `UIViewControllerContextTransitioning` and
///     `UIPercentDrivenInteractiveTransition`.
///
open class InteractiveTransitionAnimation: NSObject, TransitionAnimation {

    // MARK: - Static properties

    internal static let generateDefaultInteractionController: () -> PercentDrivenInteractionController? = {
        UIPercentDrivenInteractiveTransition()
    }

    // MARK: - Stored properties

    private let _duration: TimeInterval
    private let _animation: (UIViewControllerContextTransitioning) -> Void
    private var _generateInteractionController: () -> PercentDrivenInteractionController?

    private var _interactionController: PercentDrivenInteractionController?

    // MARK: - Computed properties

    open var interactionController: PercentDrivenInteractionController? {
        return _interactionController
    }

    // MARK: - Init

    ///
    /// Creates an InteractiveTransitionAnimation with a duration, an animation closure and a closure to
    /// generate an interaction controller.
    ///
    /// - Parameter duration:
    ///     The duration of the animation.
    ///
    /// - Parameter transition:
    ///     The animation code.
    ///
    /// - Parameter context:
    ///     The context in which the transition is performed.
    ///
    /// - Parameter generateInteractionController:
    ///     The closure to generate an interaction controller when needed,
    ///     usually at the beginning of a transition.
    ///
    public init(duration: TimeInterval,
                transition: @escaping (UIViewControllerContextTransitioning) -> Void,
                generateInteractionController: @escaping () -> PercentDrivenInteractionController?) {
        self._duration = duration
        self._animation = transition
        self._generateInteractionController = generateInteractionController
    }

    ///
    /// Convenience initializer for `init(duration:transition:generateInteractionController:)`.
    /// By ommitting the `generateInteractionController` closure, the transition will use
    /// `UIPercentDrivenInteractiveTransition` to create interaction controllers.
    ///
    /// - Parameter duration:
    ///     The duration of the animation.
    ///
    /// - Parameter transition:
    ///     The animation code.
    ///
    /// - Parameter context:
    ///     The context in which the transition is performed.
    ///
    public convenience init(duration: TimeInterval,
                            transition: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.init(
            duration: duration,
            transition: transition,
            generateInteractionController: InteractiveTransitionAnimation.generateDefaultInteractionController
        )
    }

    ///
    /// Convenience initializer for `init(duration:transition:generateInteractionController:)`.
    /// Provides a simple interface to make StaticTransitionAnimations interactive.
    ///
    /// - Parameter transitionAnimation:
    ///     The StaticTransitionAnimation to be made interactive.
    ///
    /// - Parameter generateInteractionController:
    ///     The closure to generate an interaction controller when needed,
    ///     usually at the beginning of a transition.
    ///
    public convenience init(transitionAnimation: StaticTransitionAnimation,
                            generateInteractionController: @escaping () -> PercentDrivenInteractionController?) {
        self.init(
            duration: transitionAnimation.duration,
            transition: transitionAnimation.performAnimation,
            generateInteractionController: generateInteractionController
        )
    }

    ///
    /// Convenience initializer for `init(duration:transition:)`.
    /// Provides a simple interface to make StaticTransitionAnimations interactive.
    ///
    /// - Parameter transitionAnimation:
    ///     The StaticTransitionAnimation to be made interactive.
    ///
    public convenience init(transitionAnimation: StaticTransitionAnimation) {
        self.init(
            duration: transitionAnimation.duration,
            transition: transitionAnimation.animateTransition
        )
    }

    // MARK: - Methods

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        return _animation(transitionContext)
    }

    // MARK: - TransitionAnimation

    ///
    /// This method is used to generate an applicable interaction controller.
    /// If you need more complex logic to create a specific interaction controller, override this method
    /// in your subclass.
    ///
    open func generateInteractionController() -> PercentDrivenInteractionController? {
        return _generateInteractionController()
    }

    ///
    /// Starts the transition animation by generating an interaction controller.
    ///
    open func start() {
        _interactionController = generateInteractionController()
    }

    ///
    /// Updates the interaction controller about the current progress of the animation.
    ///
    open func update(_ percentComplete: CGFloat) {
        _interactionController?.update(percentComplete)
    }

    ///
    /// Updates the interaction controller about the cancellation of the animation.
    ///
    open func cancel() {
        _interactionController?.cancel()
    }

    ///
    /// Updates the interaction controller about the finishing of the animation.
    ///
    open func finish() {
        _interactionController?.finish()
    }

    ///
    /// Ends the transition animation by deleting the interaction controller.
    ///
    open func cleanup() {
        _interactionController = nil
    }
}
