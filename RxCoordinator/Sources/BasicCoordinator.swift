//
//  BasicCoordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import UIKit

public typealias BasicNavigationCoordinator<R: Route> = BasicCoordinator<R, NavigationTransition>
public typealias BasicViewCoordinator<R: Route> = BasicCoordinator<R, ViewTransition>
public typealias BasicTabBarCoordinator<R: Route> = BasicCoordinator<R, TabBarTransition>

open class BasicCoordinator<BasicRoute: Route, TransitionType: Transition>: BaseCoordinator<BasicRoute, TransitionType> {
    public typealias CoordinatorRoute = BasicRoute

    public enum InitialLoadingType {
        case immediately
        case presented
    }

    private let initialRoute: BasicRoute?
    private let initialLoadingType: InitialLoadingType
    private let prepareTransition: ((BasicRoute) -> TransitionType)?

    public init(initialRoute: BasicRoute? = nil,
                initialLoadingType: InitialLoadingType = .presented,
                prepareTransition: ((BasicRoute) -> TransitionType)?) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.prepareTransition = prepareTransition

        if let initialRoute = initialRoute, initialLoadingType == .immediately {
            super.init(initialRoute: initialRoute)
        } else {
            super.init(initialRoute: nil)
        }
    }

    open override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)

        context = presentable?.viewController

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            trigger(initialRoute, with: TransitionOptions(animated: false), completion: nil)
        }
    }

    open override func prepareTransition(for route: BasicRoute) -> TransitionType {
        if let prepareTransition = prepareTransition {
            return prepareTransition(route)
        } else {
            fatalError("Either pass a prepareTransition closure to the initializer or override this method")
        }
    }
}
