//
//  CoordinatorContextMenuInteractionDelegate.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.02.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

#if os(iOS)

import UIKit

///
/// A `UIContextMenuInteractionDelegate` that previews and triggers a coordinator route.
///
/// The preview is the view controller produced by the route's transition; committing the preview performs
/// that route on the coordinator.
///
/// - Important:
///     The route is performed via the coordinator's ``Coordinator/performTransition(_:with:completion:)``,
///     **not** by running the transition directly. This is what keeps the presented presentables retained as
///     children of the coordinator — performing the transition directly would bypass child management and the
///     presented coordinator would be deallocated immediately (see `CoordinatorChildLifecycleTests`).
///
internal final class CoordinatorContextMenuInteractionDelegate<C: Coordinator & AnyObject>: NSObject,
                                                                                            UIContextMenuInteractionDelegate {

    // MARK: Stored properties

    private let identifier: NSCopying?
    private let route: C.RouteType
    private let menu: UIMenu?
    private weak var coordinator: C?
    private let completion: PresentationHandler?

    // MARK: Initialization

    internal init(
        coordinator: C,
        route: C.RouteType,
        identifier: NSCopying?,
        menu: UIMenu?,
        completion: PresentationHandler?
    ) {
        self.coordinator = coordinator
        self.route = route
        self.identifier = identifier
        self.menu = menu
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
                guard let self else { return nil }
                return self.coordinator?.prepareTransition(for: self.route).presentables.last?.viewController
            },
            actionProvider: { [weak self] _ in
                self?.menu
            }
        )
    }

    internal func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        animator.addCompletion { [weak self] in
            self?.performRoute()
        }
    }

    /// Performs the configured route on the coordinator, keeping child management intact.
    ///
    /// Factored out of the delegate callback so it can be exercised directly in tests without a live
    /// `UIContextMenuInteractionCommitAnimating`.
    internal func performRoute() {
        guard let coordinator else { return }
        coordinator.performTransition(
            coordinator.prepareTransition(for: route),
            with: .default,
            completion: completion
        )
    }

}

#endif
