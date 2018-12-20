//
//  UserCoordinator.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import XCoordinator

enum UserRoute: Route {
    case user(String)
    case alert(title: String, message: String)
    case users
    case emptyForAnimation
}

class UserCoordinator: NavigationCoordinator<UserRoute> {

    // MARK: - Init

    init(user: String) {
        super.init(initialRoute: .user(user))
        addPushGestureRecognizer()
    }

    // MARK: - Overrides

    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case .emptyForAnimation:
            let viewController = UIViewController()

            viewController.loadViewIfNeeded()
            viewController.view.backgroundColor = .red

            return .push(viewController, animation: .interactiveFade)
        case let .user(username):
            var vc = UserViewController.instantiateFromNib()
            let viewModel = UserViewModelImpl(router: anyRouter, username: username)
            vc.bind(to: viewModel)
            return .push(vc)
        case let .alert(title, message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            return .present(alert)
        case .users:
            return .dismiss()
        }
    }

    // MARK: - Methods

    private func addPushGestureRecognizer() {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer()
        gestureRecognizer.edges = .right
        let topView = (rootViewController.topViewController ?? rootViewController)?.view
        topView?.addGestureRecognizer(gestureRecognizer)
        registerInteractiveTransition(
            for: .emptyForAnimation,
            triggeredBy: gestureRecognizer,
            progression: { [weak topView] recognizer in
                let xTranslation = -recognizer.translation(in: topView).x
                return max(min(xTranslation / UIScreen.main.bounds.width, 1), 0)
            },
            shouldFinish: { [weak topView] recognizer in
                let xTranslation = -recognizer.translation(in: topView).x
                let xVelocity = -recognizer.velocity(in: topView).x
                return xTranslation / UIScreen.main.bounds.width >= 0.5
                    || xVelocity >= UIScreen.main.bounds.width / 2
            },
            completion: nil
        )
    }
}
