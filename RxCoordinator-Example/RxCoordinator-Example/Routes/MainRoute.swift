//
//  MainRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxCoordinator

enum MainRoute: Route {
    case login
    case home

    func prepareTransition(coordinator: AnyCoordinator<MainRoute>) -> Transition {
        switch self {
        case .login:
            var vc = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(coordinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc)
        case .home:
            let coordinator = BasicCoordinator<HomeRoute>(initialRoute: .home)
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            return .present(coordinator, animation: animation)
        }
    }
}
