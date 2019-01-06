//  
//  UserViewModel.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

protocol UserViewModelInput {
    var alertTrigger: InputSubject<Void> { get }
    var closeTrigger: InputSubject<Void> { get }
}

protocol UserViewModelOutput {
    var username: Observable<String> { get }
}

protocol UserViewModel {
    var input: UserViewModelInput { get }
    var output: UserViewModelOutput { get }
}

extension UserViewModel where Self: UserViewModelInput & UserViewModelOutput {
    var input: UserViewModelInput { return self }
    var output: UserViewModelOutput { return self }
}
