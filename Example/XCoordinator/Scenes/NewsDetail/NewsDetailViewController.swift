//  
//  NewsDetailViewController.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsDetailViewController: UIViewController, BindableType {
    var viewModel: NewsDetailViewModel!

    // MARK: - Views

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentTextView: UITextView!

    // MARK: - Stored properties

    private let disposeBag = DisposeBag()

    // MARK: - Overrides

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTextView.setContentOffset(.zero, animated: false)
    }

    // MARK: - BindableType

    func bindViewModel() {
        viewModel.output.news
            .map { $0.title + "\n" + $0.subtitle }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.news
            .map { $0.content }
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.news
            .map { $0.image }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
