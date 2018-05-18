//  
//  UsersViewModel.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCoordinator

protocol UsersViewModelInput {
    var showUserTrigger: InputSubject<String>! { get }
}

protocol UsersViewModelOutput {
    var usernames: Observable<[String]>! { get }
}

protocol UsersViewModel {
    var input: UsersViewModelInput { get }
    var output: UsersViewModelOutput { get }
}

class UsersViewModelImpl: UsersViewModel, UsersViewModelInput, UsersViewModelOutput {

    var input: UsersViewModelInput { return self }
    var output: UsersViewModelOutput { return self }

    // MARK: - Inputs
    var showUserTrigger: InputSubject<String>!

    // MARK: - Outputs
    var usernames: Observable<[String]>!

    // MARK: - Private
    private let coordinator: AnyCoordinator<HomeRoute>
    private lazy var showUserAction: Action<String, Void> = {
        return Action<String, Void> { username in
            self.coordinator.transition(to: HomeRoute.user(username))
            return .empty()
        }
    }()

    // MARK: - Init

    init(coordinator: AnyCoordinator<HomeRoute>) {
        self.coordinator = coordinator

        showUserTrigger = showUserAction.inputs
        usernames = Observable.of(["Joan", "Stefan", "Malte",
                                   "Sebi", "Patric", "Julian",
                                   "Quirin", "Paul"])
    }

}
