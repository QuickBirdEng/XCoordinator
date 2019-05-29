//
//  AboutCoordinator.swift
//  XCoordinator_Example
//
//  Created by denis on 29/05/2019.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import XCoordinator

enum AboutRoute: Route {
    
}

class AboutCoordinator: RedirectionCoordinator<AboutRoute, NavigationTransition> {
    
    // MARK: - Init
    
    init<T: TransitionPerformer>(superCoordinator: T) where T.TransitionType == NavigationTransition {
        let vc = UIViewController()
        vc.loadViewIfNeeded()
        vc.view.backgroundColor = .green
        super.init(viewController: vc, superTransitionPerformer: superCoordinator, prepareTransition: nil)
    }
    
    override func prepareTransition(for route: AboutRoute) -> NavigationTransition {
        switch route {}
    }
    
}
