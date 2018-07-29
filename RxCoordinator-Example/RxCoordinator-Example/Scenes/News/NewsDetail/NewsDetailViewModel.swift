//  
//  NewsDetailViewModel.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol NewsDetailViewModelInput {
}

protocol NewsDetailViewModelOutput {
    var title: Observable<String> { get }
    var image: Observable<UIImage?> { get }
    var content: Observable<String> { get }
}

protocol NewsDetailViewModel {
    var input: NewsDetailViewModelInput { get }
    var output: NewsDetailViewModelOutput { get }
}

extension NewsDetailViewModel where Self: NewsDetailViewModelInput & NewsDetailViewModelOutput {
    var input: NewsDetailViewModelInput { return self }
    var output: NewsDetailViewModelOutput { return self }
}
