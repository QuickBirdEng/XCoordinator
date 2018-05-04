//
//  MainScene.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import rx_coordinator

enum MainScene: Scene {
    case login(LoginViewModel)
    case home(HomeCoordinator)

    func prepareTransition() -> Transition {
        switch self {
        case let .login(viewModel):
            var vc = LoginViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .home(coordinator):
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            return .present(coordinator, animation: animation)
        }
    }
}
