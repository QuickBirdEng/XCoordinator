//  
//  NewsDetailViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import Foundation
import RxSwift

class NewsDetailViewModelImpl: NewsDetailViewModel, NewsDetailViewModelInput, NewsDetailViewModelOutput {

    // MARK: - Outputs

    let news: Observable<News>

    // MARK: - Init

    init(news: News) {
        self.news = .just(news)
    }

}
