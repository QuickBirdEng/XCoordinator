//
//  UserRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxCoordinator

enum UserRoute: Route {
    case user(String)
    case alert(title: String, message: String)
    case users
}

class UserCoordinator: NavigationCoordinator<UserRoute> {
    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case let .user(username):
            var vc = UserViewController.instantiateFromNib()
            let viewModel = UserViewModelImpl(coordinator: anyCoordinator, username: username)
            vc.bind(to: viewModel)
            return .push(vc)
        case let .alert(title, message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            alert.addAction(doneAction)
            return .present(alert)
        case .users:
            return .dismiss()
        }
    }
}


