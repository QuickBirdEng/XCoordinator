//
//  HomeRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import rx_coordinator

enum HomeRoute: Route {
    case home
    case users
    case logout

    func prepareTransition(coordinator: AnyCoordinator<HomeRoute>) -> Transition {
        switch self {
        case .home:
            var vc = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModelImpl(coodinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc)
        case .users:
            let animation = Animation(presentationAnimation: CustomPresentations.fadePresentation, dismissalAnimation: nil)
            var vc = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(coordinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc, animation: animation)
        case .logout:
            return .dismiss()
        }
    }
}
