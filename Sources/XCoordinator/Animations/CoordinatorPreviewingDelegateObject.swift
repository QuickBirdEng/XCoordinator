//
//  CoordinatorPreviewingDelegateObject.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 19.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

internal class CoordinatorPreviewingDelegateObject<TransitionType: TransitionProtocol>:
NSObject, UIViewControllerPreviewingDelegate {

    // MARK: Stored properties

    internal var context: UIViewControllerPreviewing?

    private weak var viewController: UIViewController?

    private let transition: () -> TransitionType
    private let rootViewController: TransitionType.RootViewController
    private let completion: PresentationHandler?

    // MARK: Initialization

    internal init(transition: @escaping () -> TransitionType,
                  rootViewController: TransitionType.RootViewController,
                  completion: PresentationHandler?) {
        self.transition = transition
        self.rootViewController = rootViewController
        self.completion = completion
    }

    // MARK: Methods

    internal func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                                    viewControllerForLocation location: CGPoint) -> UIViewController? {

        if let viewController = viewController {
            return viewController
        }

        let presentable = transition().presentables.last
        presentable?.presented(from: nil)
        viewController = presentable?.viewController
        return viewController
    }

    internal func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                                    commit viewControllerToCommit: UIViewController) {
        transition().perform(on: rootViewController, with: .default, completion: completion)
    }
}
