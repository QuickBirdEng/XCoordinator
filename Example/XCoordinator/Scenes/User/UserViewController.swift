//  
//  UserViewController.swift
//  XCoordinator_Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewController: UIViewController, BindableType {
    var viewModel: UserViewModel!

    // MARK: - Views

    @IBOutlet private var username: UILabel!
    @IBOutlet private var showAlertButton: UIButton!
    private var closeBarButtonItem: UIBarButtonItem!

    // MARK: - Stored properties

    private let disposeBag = DisposeBag()

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

    // MARK: - Helpers

    private func configureNavBar() {
        closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
}
