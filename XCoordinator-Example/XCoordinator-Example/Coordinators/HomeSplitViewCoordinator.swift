//
//  HomeSplitViewCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import XCoordinator

class HomeSplitViewCoordinator: SplitCoordinator<HomeRoute> {

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
        super.init(master: userListCoordinator, detail: newsCoordinator)
    }
}
