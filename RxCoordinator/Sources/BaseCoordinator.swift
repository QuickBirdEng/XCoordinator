//
//  BaseCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import UIKit

extension BaseCoordinator {
    public typealias TransitionType = CoordinatorRoute.TransitionType
    public typealias RootViewController = TransitionType.RootViewController
}

open class BaseCoordinator<CoordinatorRoute: Route>: Coordinator {
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

    public init(initialRoute: CoordinatorRoute?) {
        self.rootVCReferenceBox.set(TransitionType.generateRootViewController())
        if let initialRoute = initialRoute {
            triggerRouteAfterWindowAppeared(initialRoute)
        }
    }
    
    open func presented(from presentable: Presentable?) {
        rootVCReferenceBox.releaseStrongReference()
    }

    open func prepareTransition(for route: CoordinatorRoute) -> TransitionType {
        fatalError("Please override the \(#function) method.")
    }

    // MARK: - Helper methods

    private func triggerRouteAfterWindowAppeared(_ route: CoordinatorRoute) {
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
