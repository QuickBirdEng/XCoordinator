//
//  Transition.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

public struct Transition<RootViewController: UIViewController>: TransitionProtocol {

    // MARK: - Typealias

    public typealias Perform = (TransitionOptions, AnyTransitionPerformer<Transition<RootViewController>>, PresentationHandler?) -> Void

    // MARK: - Stored properties

    private var _presentable: Presentable?
    private var _perform: Perform

    // MARK: - Computed properties

    public var presentable: Presentable? {
        return _presentable
    }

    // MARK: - Init

    public init(presentable: Presentable?, perform: @escaping Perform) {
        self._presentable = presentable
        self._perform = perform
    }

    // MARK: - Methods

    public func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where C.TransitionType == Transition<RootViewController> {
        let anyPerformer = AnyTransitionPerformer(coordinator)
        perform(options: options, performer: anyPerformer, completion: completion)
    }

    func perform(options: TransitionOptions, performer: AnyTransitionPerformer<Transition>, completion: PresentationHandler?) {
        _perform(options, performer, completion)
    }

    // MARK: - Static methods

    public static func generateRootViewController() -> RootViewController {
        return RootViewController()
    }
}
