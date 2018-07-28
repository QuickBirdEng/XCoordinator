//
//  UserListRoute.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import RxCoordinator

enum UserListRoute: NavigationRoute {
    case home
    case users
    case user(String)
    case registerUserPeek(from: Container)
    case logout
}

class UserListCoordinator: BaseCoordinator<UserListRoute> {
    init() {
        super.init(initialRoute: .home)
    }

    override func prepareTransition(for route: UserListRoute) -> NavigationTransition {
        let coordinator = AnyCoordinator(self)
        switch route {
        case .home:
            var vc = HomeViewController.instantiateFromNib()
            let vm = HomeViewModelImpl(coodinator: coordinator)
            vc.bind(to: vm)
            return .push(vc)
        case .users:
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            var vc = UsersViewController.instantiateFromNib()
            let vm = UsersViewModelImpl.init(coordinator: coordinator)
            vc.bind(to: vm)
            return .push(vc, animation: animation)
        case .user(let username):
            let coordinator = UserCoordinator(initialRoute: .user(username))
            return .present(coordinator)
        case .registerUserPeek(let source):
            return .registerPeek(for: source, route: .user("Test"), coordinator: AnyCoordinator(self))
        case .logout:
            return .dismiss()
        }
    }
}
