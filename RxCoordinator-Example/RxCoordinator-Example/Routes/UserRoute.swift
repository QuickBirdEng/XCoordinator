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
    typealias RootType = TransitionTypeNC

    case user(String)
    case alert(title: String, message: String)
    case users
}

class UserCoordinator: BasicCoordinator<UserRoute> {

    init(initialRoute: UserRoute) {
        super.init(initialRoute: initialRoute, initialLoadingType: .presented)
    }

    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case let .user(username):
            var vc = UserViewController.instantiateFromNib()
            let viewModel = UserViewModelImpl(coordinator: AnyCoordinator(self), username: username)
            vc.bind(to: viewModel)
            return .push(vc)
        case let .alert(title, message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            return .present(alert)
        case .users:
            return .dismiss()
        }
    }
    
}


