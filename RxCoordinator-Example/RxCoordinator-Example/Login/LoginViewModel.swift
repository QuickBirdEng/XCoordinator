//  
//  LoginViewModel.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCoordinator

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
    private let coordinator: AnyCoordinator<AppRoute>

    private lazy var loginAction = CocoaAction { [weak self] in
        guard let `self` = self else { return .empty() }
        return self.coordinator.trigger(.home).presentation
    }

    // MARK: - Init

    init(coordinator: AnyCoordinator<AppRoute>) {
        self.coordinator = coordinator
    }

}
