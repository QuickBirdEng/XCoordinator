//
//  MainCoordinator.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import rx_coordinator

class MainCoordinator: Coordinator {
    typealias CoordinatorRoute = MainRoute

    var context: UIViewController!
    var navigationController = UINavigationController()

    init() {
        self.context = navigationController

        let viewModel = LoginViewModelImpl(coordinator: self)
        transition(to: .login(viewModel))
    }

}
