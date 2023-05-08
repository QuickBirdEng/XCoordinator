//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct Dismiss<RootViewController> {

    // MARK: Stored Properties

    private let toRoot: Bool
    private let animation: Animation?

    // MARK: Initialization

    public init(toRoot: Bool = false, animation: Animation? = nil) {
        self.toRoot = toRoot
        self.animation = animation
    }

}

extension Dismiss: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        Transition(
            presentables: [],
            animationInUse: animation?.dismissalAnimation
        ) { rootViewController, options, completion in
            let presentedViewController = rootViewController.topPresentedViewController
            if let animation = animation {
                presentedViewController.transitioningDelegate = animation
            }
            let dismissalViewController = toRoot ? rootViewController : presentedViewController
            dismissalViewController.dismiss(animated: options.animated, completion: completion)
        }
    }

}
