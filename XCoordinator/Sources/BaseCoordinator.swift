//
//  BaseCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import UIKit

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

        rootViewController.beginAppearanceTransition(true, animated: false)
        windowAppearanceObserver = NotificationCenter.default.addObserver(forName: .UIApplicationDidFinishLaunching, object: nil, queue: OperationQueue.main) { [weak self] notifcation in
            self?.rootViewController.endAppearanceTransition()
            self?.removeWindowObserver()
            self?.performTransition(transition, with: TransitionOptions(animated: false), completion: completion)
        }
    }

    private func removeWindowObserver() {
        if let observer = windowAppearanceObserver {
            NotificationCenter.default.removeObserver(observer)
            windowAppearanceObserver = nil
        }
    }
}
