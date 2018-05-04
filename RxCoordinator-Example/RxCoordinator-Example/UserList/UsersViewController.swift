//  
//  UsersViewController.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController, BindableType {

    var viewModel: UsersViewModel!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users"
    }

    // MARK: - BindableType

    func bindViewModel() {
        // TODO: Bind view model to UI
    }
  
}
