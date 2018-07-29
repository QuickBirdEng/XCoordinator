//  
//  NewsDetailViewModelImpl.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

class NewsDetailViewModelImpl: NewsDetailViewModel, NewsDetailViewModelInput, NewsDetailViewModelOutput {

    // MARK: - Inputs

    // MARK: - Outputs

    let title: Observable<String>
    let image: Observable<UIImage?>
    let content: Observable<String>

    // MARK: - Private

    // MARK: - Init

    init(news: News) {
        self.title = .just(news.title)
        self.content = .just(news.content)
        self.image = .just(news.image)
    }

}
