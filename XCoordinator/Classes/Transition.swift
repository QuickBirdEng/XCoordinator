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
/// `Transitions` are defined by a `Transition.Perform` closure.
/// It further provides different context information such as `Transition.presentable` and `Transition.animation`.
/// You can create your own custom transitions using `Transition.init(presentable:animation:perform:)` or
/// use one of the many provided static functions to create the most common transitions.
///
/// - Note:
///     Transitions have a generic constraint to the rootViewController in use.
///     Therefore, not all transitions are available in every coordinator.
///     Make sure to specify the `RootViewController` type of the `TransitionType` of your coordinator as precise as possible
///     to get all already available transitions.
///
public struct Transition<RootViewController: UIViewController>: TransitionProtocol {

    // MARK: - Typealias

    ///
    /// Perform is the type of closure used to perform the transition.
    ///
    /// - Parameters:
    ///     - rootViewController:
    ///         The rootViewController to perform the transition on.
    ///     - options:
    ///         The options on how to perform the transition, e.g. whether it should be animated or not.
    ///     - completion:
    ///         The completion handler of the transition.
    ///         It is called when the transition (including all animations) is completed.
    ///
    public typealias PerformClosure = (_ rootViewController: RootViewController,
                                       _ options: TransitionOptions,
                                       _ completion: PresentationHandler?) -> Void

    // MARK: - Stored properties

    private var _presentables: [Presentable]
    private var _animation: TransitionAnimation?
    private var _perform: PerformClosure

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
    /// Extending Transition with static functions to create transitions with this initializer
    /// (instead of calling this initializer in your `prepareTransition(for:)` method) is advised
    /// as it makes reuse easier.
    ///
    /// - Parameters:
    ///     - presentables:
    ///         The presentables this transition is putting into the view hierarchy, if specifiable.
    ///         These presentables are used in the deep-linking feature.
    ///     - animationInUse:
    ///         The transition animation this transition is using during the transition, i.e. the present animation
    ///         of a presenting transition or the dismissal animation of a dismissing transition.
    ///         Make sure to specify an animation here to use your transition with the
    ///         `registerInteractiveTransition` method in your coordinator.
    ///     - perform:
    ///         The perform closure executes the transition.
    ///         To create custom transitions, make sure to call the completion handler after all animations are done.
    ///         If applicable, make sure to use the TransitionOptions to, e.g., decide whether a transition should be animated or not.
    ///
    public init(presentables: [Presentable], animationInUse: TransitionAnimation?, perform: @escaping PerformClosure) {
        self._presentables = presentables
        self._animation = animationInUse
        self._perform = perform
    }

    // MARK: - Methods

    ///
    /// The method to perform a certain transition using a coordinator.
    ///
    /// - Warning:
    ///     Do not call this method directly. Instead use your coordinator's `performTransition` method or trigger
    ///     a specified route (latter option is encouraged).
    ///
    @available(*, deprecated, renamed: "perform(on:with:completion:)")
    public func perform<T: TransitionPerformer>(options: TransitionOptions,
                                                coordinator: T,
                                                completion: PresentationHandler?
        ) where T.TransitionType == Transition<RootViewController> {

        let anyPerformer = AnyTransitionPerformer(coordinator)
        perform(options: options, performer: anyPerformer, completion: completion)
    }

    @available(*, deprecated, renamed: "perform(on:with:completion:)")
    internal func perform(options: TransitionOptions,
                          performer: AnyTransitionPerformer<Transition>,
                          completion: PresentationHandler?) {
        _perform(performer.rootViewController, options, completion)
    }

    ///
    /// Performs a transition on the given viewController.
    ///
    /// - Warning:
    ///     Do not call this method directly. Instead use your coordinator's `performTransition` method or trigger
    ///     a specified route (latter option is encouraged).
    ///
    public func perform(on rootViewController: RootViewController, with options: TransitionOptions, completion: PresentationHandler?) {
        _perform(rootViewController, options, completion)
    }
}

extension Transition {

    ///
    /// Perform is the type of closure used to perform the transition.
    ///
    /// - Parameters:
    ///     - options:
    ///         The options on how to perform the transition, e.g. whether it should be animated or not.
    ///     - transitionPerformer:
    ///         The type-erased transition performer. The transition is performed on its rootViewController.
    ///     - completion:
    ///         The completion handler of the transition. It should always be called whenever the transition is completed.
    ///
    @available(*, deprecated, renamed: "PerformClosure")
    public typealias Perform = (_ options: TransitionOptions,
                                _ transitionPerformer: AnyTransitionPerformer<Transition>,
                                _ completion: PresentationHandler?) -> Void

    ///
    /// Create your custom transitions with this initializer.
    ///
    /// Extending Transition with static functions to create transitions with this initializer
    /// (instead of calling this initializer in your `prepareTransition(for:)` method) is advised
    /// as it makes reuse easier.
    ///
    /// - Parameter presentables:
    ///     The presentables this transition is putting into the view hierarchy, if specifiable.
    ///     These presentables are used in the deep-linking feature.
    ///
    @available(*, deprecated, renamed: "init(presentables:animationInUse:perform:)")
    public init(presentables: [Presentable], animation: TransitionAnimation? = nil, perform: @escaping Perform) {
        self.init(presentables: presentables, animationInUse: animation) { rootViewController, options, completion in
            let transitionPerformer = AnyTransitionPerformer(
                ViewControllerTransitionPerformer(rootViewController)
            )
            perform(options, transitionPerformer, completion)
        }
    }
}
