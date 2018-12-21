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
    case randomColor
}

class UserCoordinator: NavigationCoordinator<UserRoute> {

    // MARK: - Init

    init(user: String) {
        super.init(initialRoute: .user(user))
    }

    // MARK: - Overrides

    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case .randomColor:
            let viewController = UIViewController()
            viewController.view.backgroundColor = .random()
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

    // MARK: - Overrides

    override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)
        addPushGestureRecognizer(to: rootViewController)
    }

    // MARK: - Methods

    private func addPushGestureRecognizer(to container: Container) {
        let view = container.view
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer()
        gestureRecognizer.edges = .right
        view?.addGestureRecognizer(gestureRecognizer)

        registerInteractiveTransition(
            for: .randomColor,
            triggeredBy: gestureRecognizer,
            progress: { [weak view] recognizer in
                let xTranslation = -recognizer.translation(in: view).x
                return max(min(xTranslation / UIScreen.main.bounds.width, 1), 0)
            },
            shouldFinish: { [weak view] recognizer in
                let xTranslation = -recognizer.translation(in: view).x
                let xVelocity = -recognizer.velocity(in: view).x
                return xTranslation >= UIScreen.main.bounds.width / 2
                    || xVelocity >= UIScreen.main.bounds.width / 2
            },
            completion: nil
        )
    }
}

extension UIColor {
    fileprivate static func random(alpha: CGFloat? = 1) -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: alpha ?? CGFloat.random(in: 0...1)
        )
    }
}
