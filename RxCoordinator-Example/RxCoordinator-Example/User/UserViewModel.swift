//  
//  UserViewModel.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
import rx_coordinator

protocol UserViewModelInput {
    var alertTrigger: InputSubject<Void>! { get }
    var closeTrigger: InputSubject<Void>! { get }
}

protocol UserViewModelOutput {
    var username: Observable<String>! { get }
}

protocol UserViewModel {
    var input: UserViewModelInput { get }
    var output: UserViewModelOutput { get }
}

class UserViewModelImpl: UserViewModel, UserViewModelInput, UserViewModelOutput {

    var input: UserViewModelInput { return self }
    var output: UserViewModelOutput { return self }

    // MARK: - Inputs
    var alertTrigger: InputSubject<Void>!
    var closeTrigger: InputSubject<Void>!

    // MARK: - Outputs
    var username: Observable<String>!

    // MARK: - Private
    private let coordinator: AnyCoordinator<UserRoute>
    private lazy var alertAction: CocoaAction = {
        return CocoaAction {
            self.coordinator.transition(to: .alert(title: "Hey", message: "You are awesome!"))
            return .empty()
        }
    }()

    private lazy var closeAction: CocoaAction = {
        return CocoaAction {
            self.coordinator.transition(to: .users)
            return .empty()
        }
    }()
    // MARK: - Init

    init(coordinator: AnyCoordinator<UserRoute>, username: String) {
        self.coordinator = coordinator
        self.username = Observable.just(username)
        alertTrigger = alertAction.inputs
        closeTrigger = closeAction.inputs
    }

}
