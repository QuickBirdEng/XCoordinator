//  
//  HomeViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, BindableType {

    var viewModel: HomeViewModel!

    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var usersButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
    }

    // MARK: - BindableType

    func bindViewModel() {
        logoutButton.rx.tap
            .bind(to: viewModel.input.logoutTrigger)
            .disposed(by: disposeBag)

        usersButton.rx.tap
            .bind(to: viewModel.input.usersTrigger)
            .disposed(by: disposeBag)

        viewModel.registerUserPeek(from: usersButton)
    }
  
}
