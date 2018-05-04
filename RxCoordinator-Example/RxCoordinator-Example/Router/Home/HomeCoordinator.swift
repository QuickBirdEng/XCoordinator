//
//  HomeCoordinator.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import rx_coordinator

class HomeCoordinator: Coordinator {
    typealias CoordinatorScene = HomeScene

    var context: UIViewController
    var navigationController: UINavigationController

    init(context: UIViewController) {
        self.context = context
        navigationController = UINavigationController()
    }

    func start() {
        let viewModel = HomeViewModelImpl(coodinator: self)
        transition(to: .home(viewModel))
    }

}
