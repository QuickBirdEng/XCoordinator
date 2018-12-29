//  
//  NewsDetailViewModel.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift

protocol NewsDetailViewModelInput {
}

protocol NewsDetailViewModelOutput {
    var news: Observable<News> { get }
}

protocol NewsDetailViewModel {
    var input: NewsDetailViewModelInput { get }
    var output: NewsDetailViewModelOutput { get }
}

extension NewsDetailViewModel where Self: NewsDetailViewModelInput & NewsDetailViewModelOutput {
    var input: NewsDetailViewModelInput { return self }
    var output: NewsDetailViewModelOutput { return self }
}
