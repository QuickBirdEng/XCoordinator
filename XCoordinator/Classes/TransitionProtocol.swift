//
//  TransitionProtocol.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// `TransitionProtocol` is used to abstract any concrete transition implementation.
///
/// `Transition` is provided as an easily-extensible default transition type implementation.
///
public protocol TransitionProtocol: TransitionContext {

    /// The type of the rootViewController that can execute the transition.
    associatedtype RootViewController: UIViewController

    ///
    /// Perform the transition on the specified coordinator.
    ///
    /// - Parameters:
    ///     - options:
    ///         The options with which a transition is performed, e.g. whether the animation is to be used.
    ///     - coordinator:
    ///         The coordinator to perform the transition on.
    ///     - completion:
    ///         The completion handler. Make sure to call this, whenever the transition is completed.
    ///
    @available(*, deprecated, renamed: "perform(on:with:completion:)")
    func perform<C: Coordinator>(options: TransitionOptions,
                                 coordinator: C,
                                 completion: PresentationHandler?) where C.TransitionType == Self

    ///
    /// Performs a transition on the given viewController.
    ///
    /// - Warning:
    ///     Do not call this method directly. Instead use your coordinator's `performTransition` method or trigger
    ///     a specified route (latter option is encouraged).
    ///
    func perform(on rootViewController: RootViewController,
                 with options: TransitionOptions,
                 completion: PresentationHandler?)

    // MARK: - Always accessible transitions

    ///
    /// Creates a compound transition by chaining multiple transitions together.
    ///
    /// - Parameter transitions:
    ///     The transitions to be chained to form a combined transition.
    ///
    static func multiple(_ transitions: [Self]) -> Self
}

extension TransitionProtocol {

    ///
    /// Creates a compound transition by chaining multiple transitions together.
    ///
    /// - Parameter transitions:
    ///     The transitions to be chained to form a combined transition.
    ///
    public static func multiple(_ transitions: Self...) -> Self {
        return multiple(transitions)
    }
}
