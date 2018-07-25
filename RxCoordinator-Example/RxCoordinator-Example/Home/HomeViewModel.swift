//  
//  HomeViewModel.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCoordinator

protocol HomeViewModelInput {
    var logoutTrigger: InputSubject<Void> { get }
    var usersTrigger: InputSubject<Void> { get }
}

protocol HomeViewModelOutput {}

protocol HomeViewModel {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }

    func registerUserPeek(from sourceView: Container)
}

class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {

    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }

    // MARK: - Inputs
    lazy var logoutTrigger: InputSubject<Void> = logoutAction.inputs
    lazy var usersTrigger: InputSubject<Void> = usersAction.inputs

    // MARK: - Private
    private let coordinator: AnyCoordinator<HomeRoute>

    private lazy var logoutAction = CocoaAction { [weak self] in
        guard let `self` = self else { return .empty() }
        return self.coordinator.trigger(.logout).presentation
    }

    private lazy var usersAction = CocoaAction { [weak self] in
        guard let `self` = self else { return .empty() }
        return self.coordinator.trigger(.users).presentation
    }

    // MARK: - Init

    init(coodinator: AnyCoordinator<HomeRoute>) {
        self.coordinator = coodinator
    }

    func registerUserPeek(from sourceView: Container) {
        coordinator.trigger(.registerUserPeek(from: sourceView))
    }

}
