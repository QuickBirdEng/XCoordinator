//  
//  UsersViewModel.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import RxSwift
import Action
import XCoordinator

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

extension UsersViewModel where Self: UsersViewModelInput & UsersViewModelOutput {
    var input: UsersViewModelInput { return self }
    var output: UsersViewModelOutput { return self }
}
