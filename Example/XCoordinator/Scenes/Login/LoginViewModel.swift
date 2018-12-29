//  
//  LoginViewModel.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

protocol LoginViewModelInput {
    var loginTrigger: InputSubject<Void> { get }
}

protocol LoginViewModelOutput {}

protocol LoginViewModel {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

extension LoginViewModel where Self: LoginViewModelInput & LoginViewModelOutput {
    var input: LoginViewModelInput { return self }
    var output: LoginViewModelOutput { return self }
}
