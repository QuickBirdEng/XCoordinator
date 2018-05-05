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

    private let initalRoute: BasicRoute?
    private let initalLoadingType: InitalLoadingType

    public init(initalRoute: BasicRoute? = nil, initalLoadingType: InitalLoadingType = .presented) {
        self.initalRoute = initalRoute
        self.initalLoadingType = initalLoadingType

        if let initalRoute = initalRoute, initalLoadingType == .immediately {
            transition(to: initalRoute)
        }
    }

    open func presented(from presentable: Presentable?) {
        context = presentable?.viewController

        if let initalRoute = initalRoute, initalLoadingType == .presented {
            transition(to: initalRoute)
        }
    }

}
