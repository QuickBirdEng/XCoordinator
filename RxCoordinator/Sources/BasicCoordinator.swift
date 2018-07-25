//
//  BasicCoordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import UIKit

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
    private let prepareTransition: ((BasicRoute) -> Transition<BasicRoute.RootType>)?
    private let rootVCReferenceBox = ReferenceBox<UIViewController>()
    private var notificationObserver: Any?

    public init(initialRoute: BasicRoute? = nil,
                initialLoadingType: InitialLoadingType = .presented,
                prepareTransition: ((BasicRoute) -> Transition<BasicRoute.RootType>)? = nil) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.prepareTransition = prepareTransition
        self.rootVCReferenceBox.set(UINavigationController())

        if let initialRoute = initialRoute, initialLoadingType == .immediately {
            triggerRouteAfterWindowAppeared(initialRoute)
        }
    }

    open func presented(from presentable: Presentable?) {
        context = presentable?.viewController

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            trigger(initialRoute, with: TransitionOptions(animated: false), completion: nil)
        }

        rootVCReferenceBox.releaseStrongReference()
    }

    open func prepareTransition(for route: BasicRoute) -> Transition<BasicRoute.RootType> {
        if let prepareTransition = prepareTransition {
            return prepareTransition(route)
        } else {
            fatalError("Either pass a prepareTransition closure to the initalizer or override this method")
        }
    }

    // MARK: Deinit

    deinit {
        removeWindowObserver()
    }

    // MARK: Helpers

    private func triggerRouteAfterWindowAppeared(_ route: BasicRoute) {
        guard UIApplication.shared.keyWindow == nil else {
            return trigger(route, with: TransitionOptions(animated: false), completion: nil)
        }

        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name.UIWindowDidBecomeVisible, object: nil, queue: OperationQueue.main) { [weak self] notifcation in
            self?.removeWindowObserver()
            self?.trigger(route, with: TransitionOptions(animated: false), completion: nil)
        }
    }

    private func removeWindowObserver() {
        if let observer = self.notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

}
