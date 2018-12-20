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

extension Presentable where Self: UIViewController {
    public func presented(from presentable: Presentable?) {}
}

extension UIViewController: Presentable {}

extension Presentable where Self: UIWindow {
    public func presented(from presentable: Presentable?) {}
}

extension UIWindow: Presentable {}
