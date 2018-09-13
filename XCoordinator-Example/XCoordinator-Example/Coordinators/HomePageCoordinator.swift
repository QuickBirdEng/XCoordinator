//
//  HomePageCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import XCoordinator

class HomePageCoordinator: PageCoordinator<HomeRoute> {

    let newsCoordinator: AnyCoordinator<NewsRoute>
    let userListCoordinator: AnyCoordinator<UserListRoute>

    init(newsCoordinator: AnyCoordinator<NewsRoute> = NewsCoordinator().anyCoordinator,
         userListCoordinator: AnyCoordinator<UserListRoute> = UserListCoordinator().anyCoordinator) {
        self.newsCoordinator = newsCoordinator
        self.userListCoordinator = userListCoordinator
        
        super.init(pages: [newsCoordinator, userListCoordinator], direction: .forward, transitionStyle: .pageCurl, orientation: .horizontal, options: nil)
    }

    override func prepareTransition(for route: HomeRoute) -> PageTransition {
        switch route {
        case .news:
            return .set([newsCoordinator], direction: .forward)
        case .userList:
            return .set([userListCoordinator], direction: .forward)
        }
    }
}
