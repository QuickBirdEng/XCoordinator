//
//  AppCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case login
    case home
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    init() {
        super.init(initialRoute: .login)
    }

    var homeCoordinator: HomeCoordinator!

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            var vc = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(coordinator: anyCoordinator)
            vc.bind(to: viewModel)
            return .push(vc)
        case .home:
            self.homeCoordinator = HomeCoordinator()
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            return .present(homeCoordinator!, animation: animation)
        }
    }
}
