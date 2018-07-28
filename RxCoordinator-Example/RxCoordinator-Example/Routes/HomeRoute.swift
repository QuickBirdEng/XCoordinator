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

    let newsVC: NewsViewController = {
        var vc = NewsViewController.instantiateFromNib()
        let viewModel = NewsViewModelImpl()
        vc.bind(to: viewModel)
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        return vc
    }()

    let userListCoordinator: UserListCoordinator = {
        let coordinator = UserListCoordinator()
        coordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.more, tag: 1)
        return coordinator
    }()

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsVC)
        case .initialize:
            return .set([newsVC, userListCoordinator])
        case .userList:
            return .select(userListCoordinator)
        }
    }

}

