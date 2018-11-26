//  
//  NewsViewController.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, BindableType {
    var viewModel: NewsViewModel!

    // MARK: - Views

    @IBOutlet var tableView: UITableView!

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
            .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { index, model, cell in
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
