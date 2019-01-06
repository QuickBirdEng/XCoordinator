//
//  LoginViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class LoginViewModelImpl: LoginViewModel, LoginViewModelInput, LoginViewModelOutput {

    // MARK: - Inputs

    private(set) lazy var loginTrigger: InputSubject<Void> = loginAction.inputs

    // MARK: - Actions

    private lazy var loginAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.home)
    }

    // MARK: - Private

    private let router: AnyRouter<AppRoute>

    // MARK: - Init

    init(router: AnyRouter<AppRoute>) {
        self.router = router
    }
}
