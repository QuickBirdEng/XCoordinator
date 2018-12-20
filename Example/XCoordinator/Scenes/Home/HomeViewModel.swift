//  
//  HomeViewModel.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import RxSwift
import Action
import XCoordinator

protocol HomeViewModelInput {
    var logoutTrigger: InputSubject<Void> { get }
    var usersTrigger: InputSubject<Void> { get }
}

protocol HomeViewModelOutput {}

protocol HomeViewModel {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }

    func registerPeek(for sourceView: Container)
}

extension HomeViewModel where Self: HomeViewModelInput & HomeViewModelOutput {
    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }
}
