//  
//  UserViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewController: UIViewController, BindableType {

    var viewModel: UserViewModel!

    @IBOutlet var username: UILabel!
    @IBOutlet var showAlertButton: UIButton!

    private let disposeBag = DisposeBag()
    private var closeBarButtonItem: UIBarButtonItem!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
    }

    // MARK: - BindableType

    func bindViewModel() {
        viewModel.output.username
            .bind(to: username.rx.text)
            .disposed(by: disposeBag)

        showAlertButton.rx.tap
            .bind(to: viewModel.input.alertTrigger)
            .disposed(by: disposeBag)

        closeBarButtonItem.rx.tap
            .bind(to: viewModel.input.closeTrigger)
            .disposed(by: disposeBag)
    }

    private func configureNavBar() {
        closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
  
}
