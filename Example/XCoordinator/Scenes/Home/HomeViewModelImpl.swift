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

    private(set) lazy var logoutTrigger: AnyObserver<Void> = logoutAction.inputs
    private(set) lazy var usersTrigger: AnyObserver<Void> = usersAction.inputs

    // MARK: - Actions

    private lazy var logoutAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.logout)
    }

    private lazy var usersAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.users)
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
