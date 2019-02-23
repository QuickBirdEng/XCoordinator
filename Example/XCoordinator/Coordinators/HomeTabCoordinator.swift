//
//  HomeTabCoordinator.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import XCoordinator

enum HomeRoute: Route {
    case news
    case userList
}

class HomeTabCoordinator: TabBarCoordinator<HomeRoute> {

    // MARK: - Stored properties

    private let newsRouter: AnyRouter<NewsRoute>
    private let userListRouter: AnyRouter<UserListRoute>

    // MARK: - Init

    convenience init() {
        let newsCoordinator = NewsCoordinator()
        newsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)

        let userListCoordinator = UserListCoordinator()
        userListCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        self.init(newsRouter: StrongAnyRouter(newsCoordinator),
                  userListRouter: StrongAnyRouter(userListCoordinator))
    }

    init(newsRouter: StrongAnyRouter<NewsRoute>,
         userListRouter: StrongAnyRouter<UserListRoute>) {
        self.newsRouter = newsRouter.anyRouter
        self.userListRouter = userListRouter.anyRouter

        super.init(tabs: [newsRouter, userListRouter], select: userListRouter)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsRouter)
        case .userList:
            return .select(userListRouter)
        }
    }
}
