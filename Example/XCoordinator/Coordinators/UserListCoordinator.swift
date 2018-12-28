//
//  UserListCoordinator.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

enum UserListRoute: Route {
    case home
    case users
    case user(String)
    case registerUsersPeek(from: Container)
    case logout
}

class UserListCoordinator: NavigationCoordinator<UserListRoute> {

    // MARK: - Init
    
    init() {
        super.init(initialRoute: .home)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: UserListRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModelImpl(router: anyRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .users:
            let viewController = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(router: anyRouter)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: .fade)
        case .user(let username):
            let coordinator = UserCoordinator(user: username)
            return .present(coordinator, animation: .default)
        case .registerUsersPeek(let source):
            return registerPeek(for: source, route: .users)
        case .logout:
            return .dismiss()
        }
    }
}
