//
//  BasicCoordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation

open class BasicCoordinator<BasicRoute: Route>: Coordinator {
    public typealias CoordinatorRoute = BasicRoute

    public enum InitalLoadingType {
        case immediately
        case presented
    }

    public var context: UIViewController!
    public var navigationController = UINavigationController()

    private let initialRoute: BasicRoute?
    private let initialLoadingType: InitalLoadingType

    public init(initialRoute: BasicRoute? = nil, initialLoadingType: InitalLoadingType = .presented) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType

        if let initialRoute = initialRoute, initialLoadingType == .immediately {
            transition(to: initialRoute)
        }
    }

    open func presented(from presentable: Presentable?) {
        context = presentable?.viewController

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            transition(to: initialRoute)
        }
    }

}
