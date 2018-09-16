//  
//  NewsViewModel.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol NewsViewModelInput {
    var selectedNews: InputSubject<News> { get }
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
