//  
//  LoginViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, BindableType {
    var viewModel: LoginViewModel!

    // MARK: - Views

    @IBOutlet private var loginButton: UIButton!

    // MARK: - Stored properties
    
    private let disposeBag = DisposeBag()

    // MARK: - Overrides

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
