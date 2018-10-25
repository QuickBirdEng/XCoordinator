//
//  Coordinator+SplitView.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension TransitionPerformer where TransitionType.RootViewController: UISplitViewController {
    // TODO: animate using delegate on UISplitViewController
    func show(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            self.rootViewController.show(viewController, sender: nil)

            CATransaction.commit()
        }

//        rootViewController.animationDelegate?.animation = animation
//        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }

    // TODO: animate using delegate on UISplitViewController
    func showDetail(_ viewController: UIViewController, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            self.rootViewController.showDetailViewController(viewController, sender: nil)

            CATransaction.commit()
        }

//        rootViewController.animationDelegate?.animation = animation
//        assert(animation == nil || rootViewController.animationDelegate != nil)

        CATransaction.commit()
    }
}
