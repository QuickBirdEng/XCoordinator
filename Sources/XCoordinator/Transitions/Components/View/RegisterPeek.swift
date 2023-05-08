//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

@available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use `UIContextMenuInteraction` instead.")
public struct RegisterPeek<RootViewController, CoordinatorType: Coordinator> where CoordinatorType.TransitionType == Transition<RootViewController> {

    // MARK: Stored Properties

    private let coordinator: CoordinatorType
    private let source: any Container
    private let route: CoordinatorType.RouteType

    // MARK: Initialization

    public init(for route: CoordinatorType.RouteType, on coordinator: CoordinatorType, in source: any Container) {
        self.route = route
        self.coordinator = coordinator
        self.source = source
    }

}

extension RegisterPeek: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        let transitionGenerator = { [weak coordinator] () -> CoordinatorType.TransitionType in
            coordinator?.prepareTransition(for: route) ?? .none()
        }
        return Transition(presentables: [], animationInUse: nil) { rootViewController, _, completion in
            let delegate = CoordinatorPreviewingDelegateObject(
                transition: transitionGenerator,
                rootViewController: rootViewController,
                completion: completion
            )

            if let context = source.view.removePreviewingContext(for: CoordinatorType.TransitionType.self) {
                rootViewController.unregisterForPreviewing(withContext: context)
            }

            source.view.strongReferences.append(delegate)
            delegate.context = rootViewController.registerForPreviewing(with: delegate, sourceView: source.view)
        }
    }

}
