//
//  HomeSplitCoordinator.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomeSplitCoordinator: SplitCoordinator<HomeRoute> {

    // MARK: - Stored properties

    private let newsRouter: AnyRouter<NewsRoute>
    private let userListRouter: AnyRouter<UserListRoute>

    // MARK: - Init

    init(newsRouter: StrongAnyRouter<NewsRoute> = StrongAnyRouter(NewsCoordinator()),
         userListRouter: StrongAnyRouter<UserListRoute> = StrongAnyRouter(UserListCoordinator())) {
        self.newsRouter = newsRouter.anyRouter
        self.userListRouter = userListRouter.anyRouter

        super.init(master: userListRouter, detail: newsRouter)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> SplitTransition {
        switch route {
        case .news:
            return .showDetail(newsRouter)
        case .userList:
            return .show(userListRouter)
        }
    }
}
