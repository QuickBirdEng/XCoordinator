//
//  Coordinator+ContextMenu.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.02.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

#if os(iOS)

import UIKit

extension Coordinator where Self: AnyObject {

    ///
    /// Creates a `UIContextMenuInteractionDelegate` that generates a preview from a given route and
    /// performs that route when the preview is committed.
    ///
    /// The preview shown is the view controller produced by the route's transition. Committing the preview
    /// triggers the route on this coordinator via ``performTransition(_:with:completion:)``, so any presented
    /// presentables are correctly retained as children.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered when the preview is committed.
    ///     - identifier: An optional identifier for the context menu configuration.
    ///     - menu: The menu to be shown alongside the preview.
    ///     - completion: A closure called once the route's transition completes.
    ///
    public func contextMenuInteractionDelegate(
        for route: RouteType,
        identifier: NSCopying? = nil,
        menu: UIMenu? = nil,
        completion: PresentationHandler? = nil
    ) -> UIContextMenuInteractionDelegate {
        CoordinatorContextMenuInteractionDelegate(
            coordinator: self,
            route: route,
            identifier: identifier,
            menu: menu,
            completion: completion
        )
    }

}

#endif
