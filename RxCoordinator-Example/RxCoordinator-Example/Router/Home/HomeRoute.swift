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
    case home(HomeViewModel)
    case users(UsersViewModel)
    case logout

    func prepareTransition() -> Transition {
        switch self {
        case let .home(viewModel):
            var vc = HomeViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .users(viewModel):
            let animation = Animation(presentationAnimation: CustomPresentations.fadePresentation, dismissalAnimation: nil)
            var vc = UsersViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc, animation: animation)
        case .logout:
            return .dismiss()
        }
    }
}
