//
//  Coordinator+SplitView.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UISplitViewController {
    // animate using delegate on UISplitViewController
    func show(_ viewController: UIViewController, with options: TransitionOptions, completion: PresentationHandler?) {

        CATransaction.execute({
            self.rootViewController.show(viewController, sender: nil)
        }, completion: completion)
    }

    // animate using delegate on UISplitViewController
    func showDetail(_ viewController: UIViewController, with options: TransitionOptions, completion: PresentationHandler?) {

        CATransaction.execute({
            self.rootViewController.showDetailViewController(viewController, sender: nil)
        }, completion: completion)
    }
}
