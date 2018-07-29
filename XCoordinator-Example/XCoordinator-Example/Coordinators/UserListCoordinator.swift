//
//  UserListCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import XCoordinator

enum UserListRoute: Route {
    case home
    case users
    case user(String)
    case registerUserPeek(from: Container)
    case logout
}

class UserListCoordinator: NavigationCoordinator<UserListRoute> {
    
    init() {
        super.init(initialRoute: .home)
    }

    override func prepareTransition(for route: UserListRoute) -> NavigationTransition {
        switch route {
        case .home:
            var vc = HomeViewController.instantiateFromNib()
            let vm = HomeViewModelImpl(coodinator: anyCoordinator)
            vc.bind(to: vm)
            return .push(vc)
        case .users:
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            var vc = UsersViewController.instantiateFromNib()
            let vm = UsersViewModelImpl(coordinator: anyCoordinator)
            vc.bind(to: vm)
            return .push(vc, animation: animation)
        case .user(let username):
            let coordinator = UserCoordinator(user: username)
            return .present(coordinator)
        case .registerUserPeek(let source):
            return .registerPeek(for: source, route: .user("Test"), coordinator: self)
        case .logout:
            return .dismiss()
        }
    }
}
