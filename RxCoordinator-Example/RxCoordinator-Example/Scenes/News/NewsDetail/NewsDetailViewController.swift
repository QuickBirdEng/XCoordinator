//  
//  NewsDetailViewController.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsDetailViewController: UIViewController, BindableType {

    var viewModel: NewsDetailViewModel!

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentTextView: UITextView!

    private let disposeBag = DisposeBag()

    // MARK: - Overrides

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTextView.setContentOffset(.zero, animated: false)
    }

    // MARK: - BindableType

    func bindViewModel() {
        viewModel.output.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.content
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

}
