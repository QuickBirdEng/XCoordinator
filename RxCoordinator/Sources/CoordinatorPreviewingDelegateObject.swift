//
//  CoordinatorPreviewingDelegateObject.swift
//  rx-coordinator
//
//  Created by Stefan Kofler on 19.07.18.
//

import UIKit

class CoordinatorPreviewingDelegateObject<R: Route>: NSObject, UIViewControllerPreviewingDelegate {

    let transition: () -> R.TransitionType
    let coordinator: AnyCoordinator<R>
    let completion: PresentationHandler?
    var context: UIViewControllerPreviewing? = nil

    weak var viewController: UIViewController?

    init(transition: @escaping () -> R.TransitionType, coordinator: AnyCoordinator<R>, completion: PresentationHandler?) {
        self.transition = transition
        self.coordinator = coordinator
        self.completion = completion
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let viewController = viewController {
            return viewController
        }

        let presentable = transition().presentable
        presentable?.presented(from: nil)
        viewController = presentable?.viewController
        return viewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        _ = coordinator.performTransition(transition(), with: TransitionOptions.default)
        completion?()
    }

}
