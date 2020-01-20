//
//  InteractiveTransitionAnimation.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

// swiftlint:disable line_length

///
/// `InteractiveTransitionAnimation` provides a simple interface to create interactive transition animations.
///
/// An `InteractiveTransitionAnimation` can be created by providing the duration, the animation code
/// and (optionally) a closure to create an interaction controller.
///
/// - Note:
///     To get further information read the UIKit documentation of
///     [UIViewControllerAnimatedTransitioning](https://developer.apple.com/documentation/uikit/UIViewControllerAnimatedTransitioning),
///     [UIViewControllerInteractiveTransitioning](https://developer.apple.com/documentation/uikit/UIViewControllerInteractiveTransitioning),
///     [UIViewControllerContextTransitioning](https://developer.apple.com/documentation/uikit/UIViewControllerContextTransitioning) and
///     [UIPercentDrivenInteractiveTransition](https://developer.apple.com/documentation/uikit/UIPercentDrivenInteractiveTransition).
///
open class InteractiveTransitionAnimation: NSObject, TransitionAnimation { // swiftlint:enable line_length

    // MARK: Static properties

    internal static let generateDefaultInteractionController: () -> PercentDrivenInteractionController? = {
        UIPercentDrivenInteractiveTransition()
    }

    // MARK: Stored properties

    private let _duration: TimeInterval
    private let _animation: (UIViewControllerContextTransitioning) -> Void
    private var _generateInteractionController: () -> PercentDrivenInteractionController?

    private var _interactionController: PercentDrivenInteractionController?

    // MARK: Computed properties

    open var interactionController: PercentDrivenInteractionController? {
        _interactionController
    }

    // MARK: Initialization

    ///
    /// Creates an InteractiveTransitionAnimation with a duration, an animation closure and a closure to
    /// generate an interaction controller.
    ///
    /// - Parameters
    ///     - duration: The duration of the animation.
    ///     - transition: The animation code.
    ///     - context: The context in which the transition is performed.
    ///     - generateInteractionController:
    ///         The closure to generate an interaction controller when needed,
    ///         usually at the beginning of a transition.
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
    /// [UIPercentDrivenInteractiveTransition](https://developer.apple.com/documentation/uikit/UIPercentDrivenInteractiveTransition)
    /// to create interaction controllers.
    ///
    /// - Parameters:
    ///     - duration: The duration of the animation.
    ///     - transition: The animation code.
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
    /// Provides a simple interface to convert StaticTransitionAnimations to interactive transition animations.
    ///
    /// - Parameters:
    ///     - transitionAnimation: The StaticTransitionAnimation to be converted.
    ///     - generateInteractionController:
    ///         The closure to generate an interaction controller when needed,
    ///         usually at the beginning of a transition.
    ///
    public convenience init(transitionAnimation: StaticTransitionAnimation,
                            generateInteractionController: @escaping () -> PercentDrivenInteractionController?) {
        self.init(
            duration: transitionAnimation.duration,
            transition: transitionAnimation.animateTransition,
            generateInteractionController: generateInteractionController
        )
    }

    ///
    /// Convenience initializer for `init(duration:transition:)`.
    /// Provides a simple interface to convert StaticTransitionAnimations to interactive transition animations.
    ///
    /// - Parameter transitionAnimation:
    ///     The StaticTransitionAnimation to be converted.
    ///
    public convenience init(transitionAnimation: StaticTransitionAnimation) {
        self.init(
            duration: transitionAnimation.duration,
            transition: transitionAnimation.animateTransition
        )
    }

    // MARK: Methods

    ///
    /// See [UIViewControllerAnimatedTransitioning](https://developer.apple.com/documentation/uikit/UIViewControllerAnimatedTransitioning)
    /// for further information.
    ///
    /// - Parameter transitionContext:
    ///     The context of the transition.
    ///
    /// - Returns:
    ///     The transition duration as specified in the initializer.
    ///
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        _duration
    }

    ///
    /// See [UIViewControllerAnimatedTransitioning](https://developer.apple.com/documentation/uikit/UIViewControllerAnimatedTransitioning)
    /// for further information.
    ///
    /// - Parameter transitionContext:
    ///     The context of a transition for which the animation should be started.
    ///
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        _animation(transitionContext)
    }

    // MARK: TransitionAnimation

    ///
    /// This method is used to generate an applicable interaction controller.
    ///
    /// - Note:
    ///     To allow for more complex logic to create a specific interaction controller,
    ///     override this method in your subclass.
    ///
    open func generateInteractionController() -> PercentDrivenInteractionController? {
        _generateInteractionController()
    }

    ///
    /// Starts the transition animation by generating an interaction controller.
    ///
    open func start() {
        _interactionController = generateInteractionController()
    }

    ///
    /// Ends the transition animation by deleting the interaction controller.
    ///
    open func cleanup() {
        _interactionController = nil
    }
}
