//
//  HomePageCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomePageCoordinator: PageCoordinator<HomeRoute> {

    let newsCoordinator: AnyRouter<NewsRoute>
    let userListCoordinator: AnyRouter<UserListRoute>

    init(newsCoordinator: AnyRouter<NewsRoute> = NewsCoordinator().anyRouter,
         userListCoordinator: AnyRouter<UserListRoute> = UserListCoordinator().anyRouter) {
        self.newsCoordinator = newsCoordinator
        self.userListCoordinator = userListCoordinator
        
        super.init(pages: [newsCoordinator, userListCoordinator], direction: .forward, transitionStyle: .pageCurl, orientation: .horizontal, options: nil)
    }

    override func prepareTransition(for route: HomeRoute) -> PageTransition {
        switch route {
        case .news:
            return .set(newsCoordinator, direction: .forward)
        case .userList:
            return .set(userListCoordinator, direction: .forward)
        }
    }
}
