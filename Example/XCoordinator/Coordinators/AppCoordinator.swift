//
//  AppCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case login
    case home
    case deep
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    init() {
        super.init(initialRoute: .deep)
    }

    var homeRouter: AnyRouter<HomeRoute>!

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            var vc = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(coordinator: anyRouter)
            vc.bind(to: viewModel)
            return .push(vc)
        case .home:
            self.homeRouter = HomePageCoordinator().anyRouter
            let animation = Animation(presentationAnimation: StaticTransitionAnimation.flippingPresentation, dismissalAnimation: nil)
            return .present(homeRouter, animation: animation)
        case .deep:
            return deepLink(.login, AppRoute.home, HomeRoute.news)
        }
    }
}
