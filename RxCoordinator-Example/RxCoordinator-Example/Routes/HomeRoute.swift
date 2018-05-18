//
//  HomeRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxCoordinator

enum HomeRoute: Route {
    case home
    case users
    case user(String)
    case logout

    func prepareTransition(coordinator: AnyCoordinator<HomeRoute>) -> Transition {
        switch self {
        case .home:
            var vc = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModelImpl(coodinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc)
        case .users:
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            var vc = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(coordinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc, animation: animation)
        case .user(let username):
            let coordinator = BasicCoordinator<UserRoute>(initalRoute: .user(username))
            return .present(coordinator)
        case .logout:
            return .dismiss()
        }
    }
}
