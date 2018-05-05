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
import rx_coordinator

protocol HomeViewModelInput {
    var logoutTrigger: InputSubject<Void>! { get }
    var usersTrigger: InputSubject<Void>! { get }
}

protocol HomeViewModelOutput {
}

protocol HomeViewModel {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {

    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }

    // MARK: - Inputs
    var logoutTrigger: InputSubject<Void>!
    var usersTrigger: InputSubject<Void>!

    // MARK: - Outputs

    // MARK: - Private
    private let coordinator: AnyCoordinator<HomeRoute>

    private lazy var logoutAction: CocoaAction = {
        return CocoaAction {
            self.coordinator.transition(to: .logout)
            return .empty()
        }
    }()

    private lazy var usersAction: CocoaAction = {
        return CocoaAction {
            self.coordinator.transition(to: .users)
            return .empty()
        }
    }()

    // MARK: - Init

    init(coodinator: AnyCoordinator<HomeRoute>) {
        self.coordinator = coodinator

        logoutTrigger = logoutAction.inputs
        usersTrigger = usersAction.inputs
    }

}
