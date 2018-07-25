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
    var showUserTrigger: InputSubject<String> { get }
}

protocol UsersViewModelOutput {
    var usernames: Observable<[String]> { get }
}

protocol UsersViewModel {
    var input: UsersViewModelInput { get }
    var output: UsersViewModelOutput { get }
}

class UsersViewModelImpl: UsersViewModel, UsersViewModelInput, UsersViewModelOutput {

    var input: UsersViewModelInput { return self }
    var output: UsersViewModelOutput { return self }

    // MARK: - Inputs
    lazy var showUserTrigger: InputSubject<String> = showUserAction.inputs

    // MARK: - Outputs
    var usernames: Observable<[String]> = .just([
        "Joan", "Stefan", "Malte", "Sebi", "Patric", "Julian", "Quirin", "Paul"
    ])

    // MARK: - Private
    private let coordinator: AnyCoordinator<HomeRoute>

    private lazy var showUserAction = Action<String, Void> { [weak self] username in
        guard let `self` = self else { return .empty() }
        return self.coordinator.trigger(.user(username)).presentation
    }

    // MARK: - Init

    init(coordinator: AnyCoordinator<HomeRoute>) {
        self.coordinator = coordinator
    }

}
