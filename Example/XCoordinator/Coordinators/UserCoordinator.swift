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
}

class UserCoordinator: NavigationCoordinator<UserRoute> {

    // MARK: - Init

    init(user: String) {
        super.init(initialRoute: .user(user))
    }

    // MARK: - Overrides

    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
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
}


