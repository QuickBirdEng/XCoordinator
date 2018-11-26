//  
//  UsersViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController, BindableType {
    var viewModel: UsersViewModel!

    // MARK: - Views

    @IBOutlet var tableView: UITableView!

    // MARK: - Stored properties

    private let disposeBag = DisposeBag()
    private let cellIdentifier = String(describing: DetailTableViewCell.self)

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableViewCell()
        configureNavBar()
    }

    // MARK: - BindableType

    func bindViewModel() {
        viewModel.output.usernames
        .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) { (_, element, cell) in
            cell.textLabel?.text = element
            cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.input.showUserTrigger)
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers

    private func configureTableViewCell() {
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: String(describing: DetailTableViewCell.self))
    }

    private func configureNavBar() {
        title = "Users"
    }
}
