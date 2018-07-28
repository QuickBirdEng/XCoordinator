//
//  HomeRoute.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxCoordinator

enum HomeRoute: TabBarRoute {
    case initialize
    case news
    case userList
}

class HomeCoordinator: BaseCoordinator<HomeRoute> {

    init() {
        super.init(initialRoute: .initialize)
    }

    override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)
        trigger(.news)
    }

    let newsCoordinator: NewsCoordinator = {
        let coordinator = NewsCoordinator()
        coordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        return coordinator
    }()

    let userListCoordinator: UserListCoordinator = {
        let coordinator = UserListCoordinator()
        coordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.more, tag: 1)
        return coordinator
    }()

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsCoordinator)
        case .initialize:
            return .set([newsCoordinator, userListCoordinator])
        case .userList:
            return .select(userListCoordinator)
        }
    }

}

