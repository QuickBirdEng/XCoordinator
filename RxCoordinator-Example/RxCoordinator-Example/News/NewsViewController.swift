//  
//  NewsViewController.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, BindableType {

    var viewModel: NewsViewModel!

    @IBOutlet var tableView: UITableView!
    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    // MARK: - BindableType

    func bindViewModel() {
        let cellID = String(describing: DetailTableViewCell.self)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellID)
        viewModel.output.news
            .bind(to: tableView.rx.items(cellIdentifier: cellID)) { index, model, cell in
                cell.textLabel!.text = model.title
                cell.detailTextLabel!.text = model.subtitle
                cell.imageView!.image = model.image
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

class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}