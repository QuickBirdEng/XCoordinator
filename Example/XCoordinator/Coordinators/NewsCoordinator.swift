//
//  NewsCoordinator.swift
//  XCoordinator-Example
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

    let animation = Animation(presentationAnimation: StaticTransitionAnimation.flippingPresentation,
                              dismissalAnimation: StaticTransitionAnimation.flippingPresentation)
    
    init() {
        super.init(initialRoute: .news)
    }

    override func prepareTransition(for route: NewsRoute) -> NavigationTransition {
        switch route {
        case .news:
            var vc = NewsViewController.instantiateFromNib()
            let service = MockNewsService()
            let viewModel = NewsViewModelImpl(newsService: service, coordinator: anyRouter)
            vc.bind(to: viewModel)
            return .push(vc)
        case .newsDetail(let news):
            var vc = NewsDetailViewController.instantiateFromNib()
            let vm = NewsDetailViewModelImpl(news: news)
            vc.bind(to: vm)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.trigger(.close)
            }
            return .present(vc, animation: animation)
        case .close:
            let noAnimation = Animation(presentationAnimation: nil, dismissalAnimation: nil)
            return .dismiss(animation: noAnimation)
        }
    }
}
