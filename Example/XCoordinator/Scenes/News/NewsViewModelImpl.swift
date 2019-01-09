//  
//  NewsViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class NewsViewModelImpl: NewsViewModel, NewsViewModelInput, NewsViewModelOutput {

    // MARK: - Inputs

    lazy var selectedNews = newsSelectedAction.inputs

    // MARK: - Actions

    lazy var newsSelectedAction = Action<News, Void> { [unowned self] news in
        self.router.rx.trigger(.newsDetail(news))
    }

    // MARK: - Outputs

    lazy var news = newsObservable.map { $0.articles }
    lazy var title = newsObservable.map { $0.title }

    let newsObservable: Observable<(title: String, articles: [News])>

    // MARK: - Private

    private let newsService: NewsService
    private let router: AnyRouter<NewsRoute>

    // MARK: - Init

    init(newsService: NewsService, router: AnyRouter<NewsRoute>) {
        self.newsService = newsService
        self.newsObservable = .just(newsService.mostRecentNews())
        self.router = router
    }

}
