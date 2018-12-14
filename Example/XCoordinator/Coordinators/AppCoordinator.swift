//
//  AppCoordinator.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case login
    case home
    case newsDetail(News)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    // MARK: - Stored properties

    // HomeCoordinators must be held, since they are not held by viewModels/viewControllers
    // They do not contain any routing logic in this example application
    private var home: Presentable?

    // MARK: - Init

    init() {
        super.init(initialRoute: .login)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            var vc = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(router: anyRouter)
            vc.bind(to: viewModel)
            return .push(vc)
        case .home:
            let presentables: [Presentable] = [HomeTabCoordinator(), HomeSplitCoordinator(), HomePageCoordinator()]
            guard let presentable = presentables.randomElement() else {
                return .none()
            }
            self.home = presentable
            return .present(presentable, animation: .staticFade)
        case .newsDetail(let news):
            return deepLink(.home, HomeRoute.news, NewsRoute.newsDetail(news))
        }
    }

    // MARK: - Methods

    func notificationReceived() {
        guard let news = MockNewsService().mostRecentNews().articles.randomElement() else {
            return
        }
        self.trigger(.newsDetail(news))
    }
}
