//  
//  LoginViewControllerViewModel.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewControllerViewModelInput {
}

protocol LoginViewControllerViewModelOutput {
}

protocol LoginViewControllerViewModel {
    var input: LoginViewControllerViewModelInput { get }
    var output: LoginViewControllerViewModelOutput { get }
}

class LoginViewControllerViewModelImpl: LoginViewControllerViewModel, LoginViewControllerViewModelInput, LoginViewControllerViewModelOutput {

    var input: LoginViewControllerViewModelInput { return self }
    var output: LoginViewControllerViewModelOutput { return self }

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Private

    // MARK: - Init

    init() {
        // TODO: Inject dependencies
    }

}
