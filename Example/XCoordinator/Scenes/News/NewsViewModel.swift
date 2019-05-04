//  
//  NewsViewModel.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift

protocol NewsViewModelInput {
    var selectedNews: AnyObserver<News> { get }
}

protocol NewsViewModelOutput {
    var news: Observable<[News]> { get }
    var title: Observable<String> { get }
}

protocol NewsViewModel {
    var input: NewsViewModelInput { get }
    var output: NewsViewModelOutput { get }
}

extension NewsViewModel where Self: NewsViewModelInput & NewsViewModelOutput {
    var input: NewsViewModelInput { return self }
    var output: NewsViewModelOutput { return self }
}
