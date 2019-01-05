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

    public var presentables: [Presentable] {
        return _presentables
    }

    public var animation: TransitionAnimation? {
        return _animation
    }

    // MARK: - Init

    public init(presentables: [Presentable], animation: TransitionAnimation?, perform: @escaping Perform) {
        self._presentables = presentables
        self._animation = animation
        self._perform = perform
    }

    // MARK: - Methods

    public func perform<C: Coordinator>(options: TransitionOptions,
                                        coordinator: C,
                                        completion: PresentationHandler?)
        where C.TransitionType == Transition<RootViewController> {
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
    @available(*, deprecated, renamed: "init(presentables:animation:)")
    public init(presentables: [Presentable], perform: @escaping Perform) {
        self.init(
            presentables: presentables,
            animation: nil,
            perform: perform
        )
    }
}
