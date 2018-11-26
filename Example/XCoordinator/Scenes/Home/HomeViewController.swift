//  
//  HomeViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, BindableType {
    var viewModel: HomeViewModel!

    // MARK: - Views

    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var usersButton: UIButton!

    // MARK: - Stored properties

    private let disposeBag = DisposeBag()

    // MARK: - Overrides

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

        viewModel.registerPeek(for: usersButton)
    }
}
