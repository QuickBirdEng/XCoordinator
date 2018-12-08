//
//  BaseCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

extension BaseCoordinator {
    public typealias RootViewController = TransitionType.RootViewController
}

open class BaseCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let rootVCReferenceBox = ReferenceBox<RootViewController>()
    private var windowAppearanceObserver: Any?

    // MARK: - Computed properties

    public private(set) var rootViewController: RootViewController {
        get {
            return rootVCReferenceBox.get()!
        }
        set {
            rootVCReferenceBox.set(newValue)
        }
    }

    // MARK: - Init

    public init(initialRoute: RouteType?) {
        self.rootVCReferenceBox.set(generateRootViewController())
        if let initialRoute = initialRoute {
            let initialTransition = prepareTransition(for: initialRoute)
            performTransitionAfterWindowAppeared(initialTransition)
        }
    }

    public init(initialTransition: TransitionType?) {
        self.rootVCReferenceBox.set(generateRootViewController())
        if let initialTransition = initialTransition {
            performTransitionAfterWindowAppeared(initialTransition)
        }
    }

    // MARK: - Open methods

    open func presented(from presentable: Presentable?) {
        rootVCReferenceBox.releaseStrongReference()
    }

    open func generateRootViewController() -> RootViewController {
        return RootViewController()
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        fatalError("Please override the \(#function) method.")
    }

    // MARK: - Private methods

    private func performTransitionAfterWindowAppeared(_ transition: TransitionType) {
        guard UIApplication.shared.keyWindow == nil else {
            return performTransition(transition, with: TransitionOptions(animated: false))
        }

        rootViewController.beginAppearanceTransition(true, animated: false)
        windowAppearanceObserver = NotificationCenter.default.addObserver(forName: UIWindow.didBecomeKeyNotification, object: nil, queue: .main) { [weak self] _ in
            self?.removeWindowObserver()
            self?.performTransition(transition, with: TransitionOptions(animated: false))
            self?.rootViewController.endAppearanceTransition()
        }
    }

    private func removeWindowObserver() {
        if let observer = windowAppearanceObserver {
            NotificationCenter.default.removeObserver(observer)
            windowAppearanceObserver = nil
        }
    }
}
