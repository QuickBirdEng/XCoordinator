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

    // We need to keep a reference to the HomeCoordinator
    // as it is not held by any viewModel or viewController
    private var home: Presentable?

    // MARK: - Init

    init() {
        super.init(initialRoute: .login)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewController = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(router: anyRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .home:
            guard let presentable: Presentable =
                [
                    HomeTabCoordinator(),
                    HomeSplitCoordinator(),
                    HomePageCoordinator()
                ].randomElement() else {
                    return .none()
            }
            self.home = presentable
            return .present(presentable, animation: .fade)
        case .newsDetail(let news):
            return deepLink(AppRoute.home, HomeRoute.news, NewsRoute.newsDetail(news))
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
