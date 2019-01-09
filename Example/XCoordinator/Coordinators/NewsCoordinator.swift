//
//  NewsCoordinator.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

enum NewsRoute: Route {
    case news
    case newsDetail(News)
    case close
}

class NewsCoordinator: NavigationCoordinator<NewsRoute> {

    // MARK: - Init

    init() {
        super.init(initialRoute: .news)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: NewsRoute) -> NavigationTransition {
        switch route {
        case .news:
            let viewController = NewsViewController.instantiateFromNib()
            let service = MockNewsService()
            let viewModel = NewsViewModelImpl(newsService: service, router: anyRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .newsDetail(let news):
            let viewController = NewsDetailViewController.instantiateFromNib()
            let viewModel = NewsDetailViewModelImpl(news: news)
            viewController.bind(to: viewModel)
            let animation: Animation
            if #available(iOS 10.0, *) {
                animation = .swirl
            } else {
                animation = .scale
            }
            return .push(viewController, animation: animation)
        case .close:
            return .dismissToRoot()
        }
    }
}
