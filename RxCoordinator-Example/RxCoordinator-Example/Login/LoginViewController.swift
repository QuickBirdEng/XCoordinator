//  
//  LoginViewController.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, BindableType {

    var viewModel: LoginViewModel!

    @IBOutlet var loginButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
    }

    // MARK: - BindableType

    func bindViewModel() {
        loginButton.rx.tap
            .bind(to: viewModel.input.loginTrigger)
            .disposed(by: disposeBag)
    }
}
