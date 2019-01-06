//  
//  NewsViewController.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class NewsViewController: UIViewController, BindableType {
    var viewModel: NewsViewModel!

    // MARK: - Views

    @IBOutlet private var tableView: UITableView!

    // MARK: - Stored properties

    private let disposeBag = DisposeBag()
    private let tableViewCellIdentifier = String(describing: DetailTableViewCell.self)

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = 44
    }

    // MARK: - BindableType

    func bindViewModel() {
        viewModel.output.news
            .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { _, model, cell in
                cell.textLabel?.text = model.title
                cell.detailTextLabel?.text = model.subtitle
                cell.imageView?.image = model.image
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(News.self)
            .bind(to: viewModel.input.selectedNews)
            .disposed(by: disposeBag)

        viewModel.output.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
}
