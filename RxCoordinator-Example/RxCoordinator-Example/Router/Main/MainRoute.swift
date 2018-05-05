//
//  MainRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import rx_coordinator

enum MainRoute: Route {
    case login(LoginViewModel)
    case home

    func prepareTransition() -> Transition {
        switch self {
        case let .login(viewModel):
            var vc = LoginViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case .home:
            let coordinator = HomeCoordinator()
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            return .present(coordinator, animation: animation)
        }
    }
}
