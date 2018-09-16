//
//  HomeSplitCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomeSplitCoordinator: SplitCoordinator<HomeRoute> {

    let newsCoordinator: AnyCoordinator<NewsRoute>
    let userListCoordinator: AnyCoordinator<UserListRoute>

    init(newsCoordinator: AnyCoordinator<NewsRoute> = NewsCoordinator().anyCoordinator,
         userListCoordinator: AnyCoordinator<UserListRoute> = UserListCoordinator().anyCoordinator) {
        self.newsCoordinator = newsCoordinator
        self.userListCoordinator = userListCoordinator

        super.init(master: userListCoordinator, detail: newsCoordinator)
    }
}
