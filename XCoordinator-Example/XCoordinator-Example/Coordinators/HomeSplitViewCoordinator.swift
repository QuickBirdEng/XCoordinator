//
//  HomeSplitViewCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import XCoordinator

class HomeSplitViewCoordinator: SplitCoordinator<HomeRoute> {

    let newsCoordinator = NewsCoordinator()
    let userListCoordinator = UserListCoordinator()

    init() {
        super.init(master: userListCoordinator, detail: newsCoordinator)
    }
}
