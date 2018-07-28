//
//  NewsRoute.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import RxCoordinator

enum NewsRoute: NavigationRoute {
    case news
    case newsDetail(News)
}

class NewsCoordinator: BaseCoordinator<NewsRoute> {
    init() {
        super.init(initialRoute: .news)
    }

    override func prepareTransition(for route: NewsRoute) -> NavigationTransition {
        switch route {
        case .news:
            let coordinator = AnyCoordinator(self)
            var vc = NewsViewController.instantiateFromNib()
            let qbURL = URL(string: "https://quickbirdstudios.com/blog/feed/")!
            let service = MockNewsService()
            let viewModel = NewsViewModelImpl(newsService: service, coordinator: coordinator)
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
