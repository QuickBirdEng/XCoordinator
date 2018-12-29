//
//  CoordinatorPreviewingDelegateObject.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 19.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

class CoordinatorPreviewingDelegateObject<TransitionType: TransitionProtocol>:
    NSObject, UIViewControllerPreviewingDelegate {

    // MARK: - Stored properties

    var context: UIViewControllerPreviewing?
    weak var viewController: UIViewController?

    private let transition: () -> TransitionType
    private let performer: AnyTransitionPerformer<TransitionType>
    private let completion: PresentationHandler?

    // MARK: - Init

    init(transition: @escaping () -> TransitionType,
         performer: AnyTransitionPerformer<TransitionType>,
         completion: PresentationHandler?) {
        self.transition = transition
        self.performer = performer
        self.completion = completion
    }

    // MARK: - Methods

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let viewController = viewController {
            return viewController
        }

        let presentable = transition().presentables.last
        presentable?.presented(from: nil)
        viewController = presentable?.viewController
        return viewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        _ = performer.performTransition(transition(), with: .default)
        completion?()
    }

}
