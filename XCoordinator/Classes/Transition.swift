//
//  Transition.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// This struct represents the common implementation of the `TransitionProtocol`.
/// It is used in every of the provided `BaseCoordinator` subclasses and provides all transitions implemented in XCoordinator.
///
/// In a `Transition` struct, transitions are defined by a `Transition.Perform` closure.
/// It further provides different context information such as `Transition.presentable` and `Transition.animation`.
/// You can create your own custom transitions using `Transition.init(presentable:animation:perform:)` or
/// use one of the many provided static functions to create the most common transitions.
///
/// - Note:
///     Transitions have a generic constraint to the rootViewController in use.
///     This leads to not all transitions being available in every coordinator.
///     Make sure to specify the `RootViewController` type of the `TransitionType` of your coordinator as precise as possible
///     to get all already available transitions.
///
public struct Transition<RootViewController: UIViewController>: TransitionProtocol {

    // MARK: - Typealias

    ///
    /// Perform is the type of closure used to perform the transition.
    ///
    /// - Parameter options:
    ///     The options on how to perform the transition, e.g. whether it should be animated or not.
    ///
    /// - Parameter performer:
    ///     An AnyTransitionPerformer-object of the coordinator in use.
    ///     Use this to access the rootViewController.
    ///
    /// - Parameter completion:
    ///     The completion handler of the transition. It should always be called whenever the transition is completed.
    ///
    public typealias Perform = (_ options: TransitionOptions,
                                _ performer: AnyTransitionPerformer<Transition<RootViewController>>,
                                _ completion: PresentationHandler?) -> Void

    // MARK: - Stored properties

    private var _presentables: [Presentable]
    private var _animation: TransitionAnimation?
    private var _perform: Perform

    // MARK: - Computed properties

    ///
    /// The presentables this transition is putting into the view hierarchy. This is especially useful for
    /// deep-linking.
    ///
    public var presentables: [Presentable] {
        return _presentables
    }

    ///
    /// The transition animation this transition is using, i.e. the presentation or dismissal animation
    /// of the specified `Animation` object. If the transition does not use any transition animations, `nil`
    /// is returned.
    ///
    public var animation: TransitionAnimation? {
        return _animation
    }

    // MARK: - Initialization

    ///
    /// Create your custom transitions with this initializer.
    ///
    /// We advise to extend Transition with static functions to create transitions with this initializer
    /// instead of calling this initializer in your `prepareTransition(for:)` method.
    ///
    /// - Parameter presentables:
    ///     The presentables this transition is putting into the view hierarchy, if specifiable.
    ///     These presentables are used in the deep-linking feature.
    ///
    /// - Parameter animation:
    ///     The transition animation this transition is using during the transition, i.e. the present animation
    ///     of a presenting transition or the dismissal animation of a dismissing transition.
    ///     Make sure to specify an animation here to use your transition with the
    ///     `registerInteractiveTransition` method in your coordinator.
    ///
    public init(presentables: [Presentable], animation: TransitionAnimation?, perform: @escaping Perform) {
        self._presentables = presentables
        self._animation = animation
        self._perform = perform
    }

    // MARK: - Methods

    ///
    /// The method to perform a certain transition using a coordinator.
    ///
    /// Do not call this method directly. Instead use your coordinator's `performTransition` method or trigger
    /// a specified route (latter option is encouraged).
    ///
    public func perform<T: TransitionPerformer>(options: TransitionOptions,
                                                coordinator: T,
                                                completion: PresentationHandler?
        ) where T.TransitionType == Transition<RootViewController> {

        let anyPerformer = AnyTransitionPerformer(coordinator)
        perform(options: options, performer: anyPerformer, completion: completion)
    }

    internal func perform(options: TransitionOptions,
                          performer: AnyTransitionPerformer<Transition>,
                          completion: PresentationHandler?) {
        _perform(options, performer, completion)
    }
}

extension Transition {

    ///
    /// Create your custom transitions with this initializer.
    ///
    /// We advise to extend Transition with static functions to create transitions with this initializer
    /// instead of calling this initializer in your `prepareTransition(for:)` method.
    ///
    /// - Parameter presentables:
    ///     The presentables this transition is putting into the view hierarchy, if specifiable.
    ///     These presentables are used in the deep-linking feature.
    ///
    @available(*, deprecated, renamed: "init(presentables:animation:perform:)")
    public init(presentables: [Presentable], perform: @escaping Perform) {
        self.init(
            presentables: presentables,
            animation: nil,
            perform: perform
        )
    }
}
