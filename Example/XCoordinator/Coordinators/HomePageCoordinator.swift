//
//  HomePageCoordinator.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomePageCoordinator: PageCoordinator<HomeRoute> {

    // MARK: - Stored properties

    private let newsRouter: AnyRouter<NewsRoute>
    private let userListRouter: AnyRouter<UserListRoute>

    // MARK: - Init

    init(newsRouter: StrongAnyRouter<NewsRoute> = StrongAnyRouter(NewsCoordinator()),
         userListRouter: StrongAnyRouter<UserListRoute> = StrongAnyRouter(UserListCoordinator())) {
        self.newsRouter = newsRouter.anyRouter
        self.userListRouter = userListRouter.anyRouter
        
        super.init(
            pages: [newsRouter, userListRouter], loop: true,
            set: userListRouter, direction: .forward,
            configuration: .init(transitionStyle: .scroll)
        )
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
