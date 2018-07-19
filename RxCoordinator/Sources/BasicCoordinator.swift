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

    public enum InitialLoadingType {
        case immediately
        case presented
    }

    public var context: UIViewController!
    public var rootViewController: UIViewController {
        get {
            return rootVCReferenceBox.get()!
        }
        set {
            rootVCReferenceBox.set(newValue)
        }
    }

    private let initialRoute: BasicRoute?
    private let initialLoadingType: InitialLoadingType
    private let rootVCReferenceBox = ReferenceBox<UIViewController>()

    public init(initialRoute: BasicRoute? = nil, initialLoadingType: InitialLoadingType = .presented) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.rootVCReferenceBox.set(UINavigationController())

        if let initialRoute = initialRoute, initialLoadingType == .immediately {
            transition(to: initialRoute)
        }
    }

    open func presented(from presentable: Presentable?) {
        context = presentable?.viewController

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            transition(to: initialRoute)
        }

        rootVCReferenceBox.releaseStrongReference()
    }

}
