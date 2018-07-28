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

    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - BindableType

    func bindViewModel() {
        // TODO: Bind view model to UI
    }

}
