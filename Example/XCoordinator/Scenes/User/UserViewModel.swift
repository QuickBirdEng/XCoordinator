//  
//  UserViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
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

class UserViewModelImpl: UserViewModel, UserViewModelInput, UserViewModelOutput {

    var input: UserViewModelInput { return self }
    var output: UserViewModelOutput { return self }

    // MARK: - Inputs
    lazy var alertTrigger: InputSubject<Void> = alertAction.inputs
    lazy var closeTrigger: InputSubject<Void> = closeAction.inputs

    // MARK: - Outputs
    let username: Observable<String>

    // MARK: - Private
    private let coordinator: AnyCoordinator<UserRoute>

    private lazy var alertAction = CocoaAction { [weak self] in
        guard let `self` = self else { return .empty() }
        return self.coordinator.rx.trigger(.alert(title: "Hey", message: "You are awesome!"))
    }

    private lazy var closeAction = CocoaAction { [weak self] in
        guard let `self` = self else { return .empty() }
        return self.coordinator.rx.trigger(.users)
    }

    // MARK: - Init

    init(coordinator: AnyCoordinator<UserRoute>, username: String) {
        self.coordinator = coordinator
        self.username = .just(username)
    }

}
