//
//  BaseCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import UIKit

public typealias NavigationCoordinator<R: Route> = BaseCoordinator<R, NavigationTransition>
public typealias ViewCoordinator<R: Route> = BaseCoordinator<R, ViewTransition>
public typealias TabBarCoordinator<R: Route> = BaseCoordinator<R, TabBarTransition>

extension BaseCoordinator {
    public typealias RootViewController = TransitionType.RootViewController
}

open class BaseCoordinator<RouteType: Route, TransitionType: Transition>: Coordinator {
    public internal(set) var context: UIViewController?
    public var rootViewController: RootViewController {
        get {
            return rootVCReferenceBox.get()!
        }
        set {
            rootVCReferenceBox.set(newValue)
        }
    }

    private let rootVCReferenceBox = ReferenceBox<RootViewController>()
    private var windowAppearanceObserver: Any?

    public init(initialRoute: RouteType?) {
        self.rootVCReferenceBox.set(TransitionType.generateRootViewController())
        if let initialRoute = initialRoute {
            triggerRouteAfterWindowAppeared(initialRoute)
        }
    }

    open func presented(from presentable: Presentable?) {
        DispatchQueue.main.async {
            self.rootVCReferenceBox.releaseStrongReference()
        }
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        fatalError("Please override the \(#function) method.")
    }

    // MARK: - Helper methods

    private func triggerRouteAfterWindowAppeared(_ route: RouteType) {
        guard UIApplication.shared.keyWindow == nil else {
            return trigger(route, with: TransitionOptions(animated: false), completion: nil)
        }

        rootViewController.beginAppearanceTransition(true, animated: false)
        windowAppearanceObserver = NotificationCenter.default.addObserver(forName: .UIApplicationDidFinishLaunching, object: nil, queue: OperationQueue.main) { [weak self] notifcation in
            self?.rootViewController.endAppearanceTransition()
            self?.removeWindowObserver()
            self?.trigger(route, with: TransitionOptions(animated: false), completion: nil)
        }
    }

    private func removeWindowObserver() {
        if let observer = windowAppearanceObserver {
            NotificationCenter.default.removeObserver(observer)
            windowAppearanceObserver = nil
        }
    }
}
