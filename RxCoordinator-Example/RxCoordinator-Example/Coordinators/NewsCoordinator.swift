//
//  NewsCoordinator.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import RxCoordinator

enum NewsRoute: Route {
    case news
    case newsDetail(News)
}

class NewsCoordinator: NavigationCoordinator<NewsRoute> {
    init() {
        super.init(initialRoute: .news)
    }

    override func prepareTransition(for route: NewsRoute) -> NavigationTransition {
        let `self` = AnyCoordinator(self)
        switch route {
        case .news:
            var vc = NewsViewController.instantiateFromNib()
            let service = MockNewsService()
            let viewModel = NewsViewModelImpl(newsService: service, coordinator: self)
            vc.bind(to: viewModel)
            return .push(vc)
        case .newsDetail(let news):
            var vc = NewsDetailViewController.instantiateFromNib()
            let vm = NewsDetailViewModelImpl(news: news)
            vc.bind(to: vm)
            return .push(vc)
        }
    }
}
