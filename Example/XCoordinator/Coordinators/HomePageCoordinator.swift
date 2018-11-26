//
//  HomePageCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomePageCoordinator: PageCoordinator<HomeRoute> {

    // MARK: - Stored properties

    let newsRouter: AnyRouter<NewsRoute>
    let userListRouter: AnyRouter<UserListRoute>

    // MARK: - Init

    init(newsRouter: AnyRouter<NewsRoute> = NewsCoordinator().anyRouter,
         userListRouter: AnyRouter<UserListRoute> = UserListCoordinator().anyRouter) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter
        
        super.init(pages: [newsRouter, userListRouter], direction: .forward, transitionStyle: .pageCurl, orientation: .horizontal, options: nil)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> PageTransition {
        switch route {
        case .news:
            return .set(newsRouter, direction: .forward)
        case .userList:
            return .set(userListRouter, direction: .reverse)
        }
    }
}
