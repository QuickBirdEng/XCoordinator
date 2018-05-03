//
//  AppCoordinator.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import rx_coordinator

class AppCoordinator: Coordinator {
    typealias CoordinatorScene = AppScene

    var context: UIViewController
    var navigationController: UINavigationController

    init(context: UINavigationController) {
        self.context = context
        self.navigationController = context
    }

    func start() {
        let viewModel = LoginViewModelImpl()
        transition(to: .login(viewModel))
    }
}
