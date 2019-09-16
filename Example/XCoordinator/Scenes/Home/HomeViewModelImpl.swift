//
//  HomeViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {

    // MARK: - Inputs

    private(set) lazy var logoutTrigger = logoutAction.inputs
    private(set) lazy var usersTrigger = usersAction.inputs
    private(set) lazy var aboutTrigger = aboutAction.inputs

    // MARK: - Actions

    private lazy var logoutAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.logout)
    }

    private lazy var usersAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.users)
    }

    private lazy var aboutAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.about)
    }
    // MARK: - Private

    private let router: AnyRouter<UserListRoute>

    // MARK: - Init

    init(router: AnyRouter<UserListRoute>) {
        self.router = router
    }

    // MARK: - Methods

    func registerPeek(for sourceView: Container) {
        router.trigger(.registerUsersPeek(from: sourceView))
    }
}
