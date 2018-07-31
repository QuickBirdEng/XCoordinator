//
//  HomeCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import XCoordinator

enum HomeRoute: Route {
    case news
    case userList
}

class HomeCoordinator: TabBarCoordinator<HomeRoute> {

    let newsCoordinator: NewsCoordinator = {
        let coordinator = NewsCoordinator()
        coordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        return coordinator
    }()

    let userListCoordinator: UserListCoordinator = {
        let coordinator = UserListCoordinator()
        coordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        return coordinator
    }()

    init() {
        super.init(tabs: [newsCoordinator, userListCoordinator], select: userListCoordinator)
    }

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsCoordinator)
        case .userList:
            return .select(userListCoordinator)
        }
    }
}
