//
//  InteractiveTransitionAnimation.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

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

    public init(duration: TimeInterval,
                transition: @escaping (UIViewControllerContextTransitioning) -> Void,
                generateInteractionController: @escaping () -> PercentDrivenInteractionController?) {
        self._duration = duration
        self._animation = transition
        self._generateInteractionController = generateInteractionController
    }

    public convenience init(duration: TimeInterval,
                            transition: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.init(
            duration: duration,
            transition: transition,
            generateInteractionController: InteractiveTransitionAnimation.generateDefaultInteractionController
        )
    }

    public convenience init(transitionAnimation: StaticTransitionAnimation,
                            generateInteractionController: @escaping () -> PercentDrivenInteractionController?) {
        self.init(
            duration: transitionAnimation.duration,
            transition: transitionAnimation.performAnimation,
            generateInteractionController: generateInteractionController
        )
    }

    public convenience init(transitionAnimation: StaticTransitionAnimation) {
        self.init(
            duration: transitionAnimation.duration,
            transition: transitionAnimation.performAnimation
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

    open func generateInteractionController() -> PercentDrivenInteractionController? {
        return _generateInteractionController()
    }

    open func start() {
        _interactionController = generateInteractionController()
    }

    open func update(_ percentComplete: CGFloat) {
        _interactionController?.update(percentComplete)
    }

    open func cancel() {
        _interactionController?.cancel()
    }

    open func finish() {
        _interactionController?.finish()
    }

    open func cleanup() {
        _interactionController = nil
    }
}
