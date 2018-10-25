//
//  HomeSplitCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomeSplitCoordinator: SplitCoordinator<HomeRoute> {

    let newsCoordinator: AnyRouter<NewsRoute>
    let userListCoordinator: AnyRouter<UserListRoute>

    init(newsCoordinator: AnyRouter<NewsRoute> = NewsCoordinator().anyRouter,
         userListCoordinator: AnyRouter<UserListRoute> = UserListCoordinator().anyRouter) {
        self.newsCoordinator = newsCoordinator
        self.userListCoordinator = userListCoordinator

        super.init(master: userListCoordinator, detail: newsCoordinator)
    }
}
