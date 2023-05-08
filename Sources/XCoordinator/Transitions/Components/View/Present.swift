//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct Present<RootViewController> {

    // MARK: Stored Properties

    private let animation: Animation?
    private let onRoot: Bool
    private let presentable: () -> any Presentable

    // MARK: Initialization

    public init(
        onRoot: Bool = false,
        animation: Animation? = nil,
        _ presentable: @escaping () -> any Presentable
    ) {
        self.animation = animation
        self.onRoot = onRoot
        self.presentable = presentable
    }

}

extension Present: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        let presentable = presentable()
        return Transition(presentables: [presentable], animationInUse: animation?.presentationAnimation) { rootViewController, options, completion in
            if let animation { presentable.viewController.transitioningDelegate = animation }
            let presentingViewController = onRoot ? rootViewController : rootViewController.topPresentedViewController
            presentingViewController.present(presentable.viewController, animated: options.animated, completion: completion)
        }
    }

}
