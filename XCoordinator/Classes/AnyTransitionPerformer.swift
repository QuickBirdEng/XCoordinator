//
//  AnyTransitionPerformer.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public class AnyTransitionPerformer<TransitionType: TransitionProtocol>: TransitionPerformer {

    // MARK: - Stored properties

    private var _viewController: () -> UIViewController?
    private var _rootViewController: () -> TransitionType.RootViewController
    private var _presented: (Presentable?) -> Void
    private var _perform: (TransitionType, TransitionOptions, PresentationHandler?) -> Void

    // MARK: - Computed properties

    public var viewController: UIViewController! {
        return _viewController()
    }

    public var rootViewController: TransitionType.RootViewController {
        return _rootViewController()
    }

    // MARK: - Methods

    public func presented(from presentable: Presentable?) {
        return _presented(presentable)
    }

    public func performTransition(_ transition: TransitionType,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler? = nil) {
        _perform(transition, options, completion)
    }

    // MARK: - Init

    init<T: TransitionPerformer>(_ coordinator: T) where TransitionType == T.TransitionType {
        self._viewController = { coordinator.viewController }
        self._presented = coordinator.presented
        self._rootViewController = { coordinator.rootViewController }
        self._perform = coordinator.performTransition
    }
}
