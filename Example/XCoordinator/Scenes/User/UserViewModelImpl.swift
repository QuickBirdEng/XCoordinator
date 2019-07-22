//
//  UserViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class UserViewModelImpl: UserViewModel, UserViewModelInput, UserViewModelOutput {

    // MARK: - Inputs

    private(set) lazy var alertTrigger: AnyObserver<Void> = alertAction.inputs
    private(set) lazy var closeTrigger: AnyObserver<Void> = closeAction.inputs

    // MARK: - Actions

    private lazy var alertAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.alert(title: "Hey", message: "You are awesome!"))
    }

    private lazy var closeAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.users)
    }

    // MARK: - Outputs

    let username: Observable<String>

    // MARK: - Private

    private let router: AnyRouter<UserRoute>

    // MARK: - Init

    init(router: AnyRouter<UserRoute>, username: String) {
        self.router = router
        self.username = .just(username)
    }
}
