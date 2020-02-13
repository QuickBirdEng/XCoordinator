//
//  CoordinatorContextMenuInteractionDelegate.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.02.20.
//

import UIKit

@available(iOS 13.0, *)
internal class CoordinatorContextMenuInteractionDelegate<TransitionType: TransitionProtocol>: NSObject, UIContextMenuInteractionDelegate {

    // MARK: Stored properties

    private let identifier: NSCopying?
    private let transition: () -> TransitionType
    private let menu: UIMenu?

    private let rootViewController: TransitionType.RootViewController
    private let completion: PresentationHandler?

    // MARK: Initialization

    internal init(
        identifier: NSCopying?,
        transition: @escaping () -> TransitionType,
        rootViewController: TransitionType.RootViewController,
        menu: UIMenu?,
        completion: PresentationHandler?
    ) {
        self.identifier = identifier
        self.transition = transition
        self.menu = menu
        self.rootViewController = rootViewController
        self.completion = completion
    }

    // MARK: Methods

    internal func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: { [weak self] in
                self?.transition().presentables.last?.viewController
            },
            actionProvider:  { [weak self] _ in
                self?.menu
            }
        )
    }

    internal func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willDisplayMenuFor configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        print(#function)
    }

    internal func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        transition().perform(on: rootViewController,
                             with: .default,
                             completion: completion)
    }

    internal func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willEndFor configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        completion?()
    }

}
