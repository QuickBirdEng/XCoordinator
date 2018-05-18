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
    var loginTrigger: InputSubject<Void>! { get }
}

protocol LoginViewModelOutput {
}

protocol LoginViewModel {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

class LoginViewModelImpl: LoginViewModel, LoginViewModelInput, LoginViewModelOutput {

    var input: LoginViewModelInput { return self }
    var output: LoginViewModelOutput { return self }

    // MARK: - Inputs
    var loginTrigger: InputSubject<Void>!

    // MARK: - Outputs

    // MARK: - Private
    private let coordinator: AnyCoordinator<MainRoute>
    private lazy var loginAction: CocoaAction = {
        return CocoaAction {
            self.coordinator.transition(to: .home)
            return .empty()
        }
    }()

    // MARK: - Init

    init(coordinator: AnyCoordinator<MainRoute>) {
        self.coordinator = coordinator

        loginTrigger = loginAction.inputs
    }
}
