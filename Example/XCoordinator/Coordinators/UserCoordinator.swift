//
//  UserCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import XCoordinator

enum UserRoute: Route {
    case user(String)
    case alert(title: String, message: String)
    case users
}

class UserCoordinator: NavigationCoordinator<UserRoute> {
    
    init(user: String) {
        super.init(initialRoute: .user(user))
    }

    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case let .user(username):
            var vc = UserViewController.instantiateFromNib()
            let viewModel = UserViewModelImpl(coordinator: anyCoordinator, username: username)
            vc.bind(to: viewModel)
            return .push(vc)
        case let .alert(title, message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default, handler: nil))
            return .present(alert)
        case .users:
            return .dismiss()
        }
    }
}


