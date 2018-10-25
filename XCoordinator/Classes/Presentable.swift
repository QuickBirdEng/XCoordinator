//
//  Presentable.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol Presentable {
    var viewController: UIViewController! { get }

    func presented(from presentable: Presentable?)
    func setRoot(for window: UIWindow)
}

extension Presentable {
    public func setRoot(for window: UIWindow) {
        window.rootViewController = viewController
        presented(from: window)
        window.makeKeyAndVisible()
    }
}

extension UIViewController: Presentable {
    public func presented(from presentable: Presentable?) {}
}

extension UIWindow: Presentable {
    public func presented(from presentable: Presentable?) {}
}
