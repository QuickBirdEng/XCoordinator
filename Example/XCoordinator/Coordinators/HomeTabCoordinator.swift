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

    private let newsPresentable: Presentable
    private let userListPresentable: Presentable

    // MARK: - Init

    convenience init() {
        let newsCoordinator = NewsCoordinator()
        newsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)

        let userListCoordinator = UserListCoordinator()
        userListCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        self.init(newsPresentable: newsCoordinator,
                  userListPresentable: userListCoordinator)
    }

    init(newsPresentable: Presentable,
         userListPresentable: Presentable) {
        self.newsPresentable = newsPresentable
        self.userListPresentable = userListPresentable

        super.init(tabs: [newsPresentable, userListPresentable], select: userListPresentable)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsPresentable)
        case .userList:
            return .select(userListPresentable)
        }
    }
}
