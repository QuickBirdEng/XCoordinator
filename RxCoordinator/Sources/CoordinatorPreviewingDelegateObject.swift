//
//  CoordinatorPreviewingDelegateObject.swift
//  rx-coordinator
//
//  Created by Stefan Kofler on 19.07.18.
//

import UIKit

class CoordinatorPreviewingDelegateObject<C: Coordinator>: NSObject, UIViewControllerPreviewingDelegate {

    // MARK: - Stored properties

    var context: UIViewControllerPreviewing? = nil
    weak var viewController: UIViewController?

    private let transition: () -> C.TransitionType
    private let coordinator: C
    private let completion: PresentationHandler?

    // MARK: - Init

    init(transition: @escaping () -> C.TransitionType, coordinator: C, completion: PresentationHandler?) {
        self.transition = transition
        self.coordinator = coordinator
        self.completion = completion
    }

    // MARK: - Methods

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
