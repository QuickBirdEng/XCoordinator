//  
//  LoginViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import RxSwift
import Action
import XCoordinator

protocol LoginViewModelInput {
    var loginTrigger: InputSubject<Void> { get }
}

protocol LoginViewModelOutput {}

protocol LoginViewModel {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

class LoginViewModelImpl: LoginViewModel, LoginViewModelInput, LoginViewModelOutput {

    var input: LoginViewModelInput { return self }
    var output: LoginViewModelOutput { return self }

    // MARK: - Inputs
    lazy var loginTrigger: InputSubject<Void> = loginAction.inputs

    // MARK: - Private
    private let coordinator: AnyRouter<AppRoute>

    private lazy var loginAction = CocoaAction { [weak self] in
        guard let `self` = self else { return .empty() }
        return self.coordinator.rx.trigger(.home)
    }

    // MARK: - Init

    init(coordinator: AnyRouter<AppRoute>) {
        self.coordinator = coordinator
    }

}
