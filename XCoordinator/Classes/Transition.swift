//
//  Transition.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public struct Transition<RootViewController: UIViewController>: TransitionProtocol {

    // MARK: - Typealias

    public typealias Perform = (TransitionOptions, AnyTransitionPerformer<Transition<RootViewController>>, PresentationHandler?) -> Void

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
    @available(*, deprecated, renamed: "init(presentables:animation:perform:)")
    public init(presentables: [Presentable], perform: @escaping Perform) {
        self.init(
            presentables: presentables,
            animation: nil,
            perform: perform
        )
    }
}
