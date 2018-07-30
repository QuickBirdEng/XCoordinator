//
//  HomePageViewCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import XCoordinator

class HomePageViewCoordinator: PageCoordinator<HomeRoute> {

    let newsCoordinator = NewsCoordinator()
    let userListCoordinator = UserListCoordinator()

    init() {
        super.init(pages: [newsCoordinator, userListCoordinator], direction: .forward, transitionStyle: .scroll, orientation: .horizontal, options: nil)
    }

    override func prepareTransition(for route: HomeRoute) -> PageViewTransition {
        switch route {
        case .news:
            return .set([newsCoordinator], direction: .forward)
        case .userList:
            return .set([userListCoordinator], direction: .forward)
        }
    }
}
