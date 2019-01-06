//
//  TransitionProtocol.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// TransitionProtocol is used to abstract away from any concrete implementation of transitions.
///
/// We provide an easily-extensible transition type called `Transition` as a default transition type.
///
public protocol TransitionProtocol {

    /// The type of the rootViewController that can execute the transition.
    associatedtype RootViewController: UIViewController

    /// The presentables being shown to the user by this transition.
    var presentables: [Presentable] { get }

    ///
    /// The transition animation directly used in the transition, if applicable.
    ///
    /// Make sure to not return `nil`,
    /// if you want to use `BaseCoordinator.registerInteractiveTransition` to realize an interactive transition.
    ///
    var animation: TransitionAnimation? { get }

    ///
    /// Perform the transition on the specified coordinator.
    ///
    /// - Parameter options:
    ///     The options with which a transition is performed, e.g. whether the animation is to be used.
    ///
    /// - Parameter coordinator:
    ///     The coordinator to perform the transition on.
    ///
    /// - Parameter completion:
    ///     The completion handler. Make sure to call this, whenever the transition is completed.
    ///
    func perform<C: Coordinator>(options: TransitionOptions,
                                 coordinator: C,
                                 completion: PresentationHandler?) where C.TransitionType == Self

    // MARK: - Always accessible transitions

    ///
    /// Create one transition by chaining multiple transitions together.
    ///
    /// - Parameter transitions:
    ///     The transitions to be chained to form a combined transition.
    ///
    static func multiple(_ transitions: [Self]) -> Self
}

extension TransitionProtocol {

    ///
    /// Create one transition by chaining multiple transitions together.
    ///
    /// - Parameter transitions:
    ///     The transitions to be chained to form a combined transition.
    ///
    public static func multiple(_ transitions: Self...) -> Self {
        return multiple(transitions)
    }
}
