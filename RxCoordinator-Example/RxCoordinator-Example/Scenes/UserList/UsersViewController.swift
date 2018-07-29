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

    @IBOutlet var tableView: UITableView!

    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableViewCell()
        configureNavBar()
    }

    // MARK: - BindableType

    func bindViewModel() {
        viewModel.output.usernames
        .bind(to: tableView.rx.items(cellIdentifier: "UserCell", cellType: UITableViewCell.self)) { (_, element, cell) in
           cell.textLabel?.text = element
        }
        .disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.input.showUserTrigger)
            .disposed(by: disposeBag)
    }

    private func configureTableViewCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }

    private func configureNavBar() {
        title = "Users"
    }
  
}



