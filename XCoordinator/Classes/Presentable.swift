//
//  Presentable.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol Presentable {
    var viewController: UIViewController! { get }

    func router<R: Route>(for route: R) -> AnyRouter<R>?
    func presented(from presentable: Presentable?)
    func setRoot(for window: UIWindow)
}

extension Presentable {
    public func setRoot(for window: UIWindow) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        presented(from: window)
    }

    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return self as? AnyRouter<R>
    }
}

extension UIViewController: Presentable {
    open func presented(from presentable: Presentable?) {}
}

extension UIWindow: Presentable {
    open func presented(from presentable: Presentable?) {}
}
