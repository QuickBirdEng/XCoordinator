//
//  HomeRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxCoordinator

enum HomeRoute: NavigationRoute {
    case home
    case users
    case user(String)
    case registerUserPeek(from: Container)
    case logout
}

class HomeCoordinator: BaseCoordinator<HomeRoute> {

    init() {
        super.init(initialRoute: .home)
    }

    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .home:
            var vc = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModelImpl(coodinator: AnyCoordinator(self))
            vc.bind(to: viewModel)
            return .push(vc)
        case .users:
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            var vc = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(coordinator: AnyCoordinator(self))
            vc.bind(to: viewModel)
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

