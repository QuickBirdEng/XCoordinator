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

protocol UsersViewModelInput {
}

protocol UsersViewModelOutput {
}

protocol UsersViewModel {
    var input: UsersViewModelInput { get }
    var output: UsersViewModelOutput { get }
}

class UsersViewModelImpl: UsersViewModel, UsersViewModelInput, UsersViewModelOutput {

    var input: UsersViewModelInput { return self }
    var output: UsersViewModelOutput { return self }

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Private
    private let coordinator: HomeCoordinator

    // MARK: - Init

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

}
