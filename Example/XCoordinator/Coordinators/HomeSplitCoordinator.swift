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

    private let newsPresentable: Presentable
    private let userListPresentable: Presentable

    // MARK: - Init

    init(newsPresentable: Presentable = NewsCoordinator(),
         userListPresentable: Presentable = UserListCoordinator()) {
        self.newsPresentable = newsPresentable
        self.userListPresentable = userListPresentable

        super.init(master: userListPresentable, detail: newsPresentable)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> SplitTransition {
        switch route {
        case .news:
            return .showDetail(newsPresentable)
        case .userList:
            return .show(userListPresentable)
        }
    }
}
