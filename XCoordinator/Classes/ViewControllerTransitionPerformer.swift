//
//  ViewControllerTransitionPerformer.swift
//  XCoordinator
//
//  Created by Paul Kraft on 04.02.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

@available(*, deprecated)
class ViewControllerTransitionPerformer<RootViewController: UIViewController>: TransitionPerformer {

    // MARK: - Stored properties

    let rootViewController: RootViewController

    // MARK: - Init

    init(_ rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }

    // MARK: - Computed properties

    var viewController: UIViewController! {
        return rootViewController
    }

    // MARK: - Presentable

    func presented(from presentable: Presentable?) {}

    // MARK: - TransitionPerformer

    func performTransition(_ transition: Transition<RootViewController>,
                           with options: TransitionOptions, completion: PresentationHandler?) {
        transition.perform(on: rootViewController, with: options, completion: completion)
    }
}
