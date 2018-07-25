//
//  MainRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxCoordinator

enum AppRoute: Route {
    typealias RootType = TransitionTypeNC

    case login
    case home
}

class AppCoordinator: BasicCoordinator<AppRoute> {

    init() {
        super.init(initialRoute: .login, initialLoadingType: .immediately)
    }

    override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)

        self.trigger(.home, with: TransitionOptions(animated: false), completion: nil)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            var vc = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(coordinator: AnyCoordinator(self))
            vc.bind(to: viewModel)
            return .push(vc)
        case .home:
            let coordinator = HomeCoordinator()
            let animation = Animation(presentationAnimation: CustomPresentations.flippingPresentation, dismissalAnimation: nil)
            return .present(coordinator, animation: animation)
        }
    }

}
