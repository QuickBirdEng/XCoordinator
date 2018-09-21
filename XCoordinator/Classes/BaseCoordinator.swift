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

    public internal(set) var context: UIViewController?

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
            performTransitionAfterWindowAppeared(initialTransition, completion: nil)
        }
    }

    public init(initialTransition: TransitionType?, completion: ((BaseCoordinator) -> Void)? = nil) {
        self.rootVCReferenceBox.set(generateRootViewController())
        if let initialTransition = initialTransition {
            performTransitionAfterWindowAppeared(initialTransition, completion: { completion?(self) })
        }
    }

    // MARK: - Open methods

    open func presented(from presentable: Presentable?) {
        context = presentable?.viewController

        DispatchQueue.main.async {
            self.rootVCReferenceBox.releaseStrongReference()
        }
    }

    open func generateRootViewController() -> RootViewController {
        return TransitionType.generateRootViewController()
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        fatalError("Please override the \(#function) method.")
    }

    // MARK: - Private methods

    private func performTransitionAfterWindowAppeared(_ transition: TransitionType, completion: PresentationHandler?) {
        guard UIApplication.shared.keyWindow == nil else {
            return performTransition(transition, with: TransitionOptions(animated: false), completion: completion)
        }

        windowAppearanceObserver = NotificationCenter.default.addObserver(forName: UIWindow.didBecomeKeyNotification, object: nil, queue: OperationQueue.main) { [weak self] notifcation in
            self?.removeWindowObserver()
            print("will transition")
            self?.performTransition(transition, with: TransitionOptions(animated: false), completion: completion)
            print("did transition")
            // self?.rootViewController.beginAppearanceTransition(true, animated: false)
            // self?.rootViewController.endAppearanceTransition()
        }
    }

    private func removeWindowObserver() {
        if let observer = windowAppearanceObserver {
            NotificationCenter.default.removeObserver(observer)
            windowAppearanceObserver = nil
        }
    }
}
