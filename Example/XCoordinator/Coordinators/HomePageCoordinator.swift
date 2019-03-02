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

    private let newsPresentable: Presentable
    private let userListPresentable: Presentable

    // MARK: - Init

    init(newsPresentable: Presentable = NewsCoordinator(),
         userListPresentable: Presentable = UserListCoordinator()) {
        self.newsPresentable = newsPresentable
        self.userListPresentable = userListPresentable
        
        super.init(
            pages: [newsPresentable, userListPresentable], loop: true,
            set: userListPresentable, direction: .forward,
            configuration: .init(transitionStyle: .scroll)
        )
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> PageTransition {
        switch route {
        case .news:
            return .set(newsPresentable, direction: .forward)
        case .userList:
            return .set(userListPresentable, direction: .reverse)
        }
    }
}
