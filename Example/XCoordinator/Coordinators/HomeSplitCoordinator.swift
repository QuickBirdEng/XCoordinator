//
//  HomeSplitCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomeSplitCoordinator: SplitCoordinator<HomeRoute> {

    // MARK: - Stored properties

    let newsRouter: AnyRouter<NewsRoute>
    let userListRouter: AnyRouter<UserListRoute>

    // MARK: - Init

    init(newsRouter: AnyRouter<NewsRoute> = NewsCoordinator().anyRouter,
         userListRouter: AnyRouter<UserListRoute> = UserListCoordinator().anyRouter) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(master: userListRouter, detail: newsRouter)
    }
}
