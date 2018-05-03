//  
//  LoginViewModel.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewModelInput {
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

    // MARK: - Outputs

    // MARK: - Private

    // MARK: - Init

    init() {
        // TODO: Inject dependencies
    }

}
