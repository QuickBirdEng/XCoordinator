//
//  Presentable.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol Presentable {
    var viewController: UIViewController! { get }

    ///
    /// This method can be used to retrieve whether the presentable can trigger a specific route
    /// and potentially returns a router to trigger the route on.
    ///
    /// Deep linking makes use of this method to trigger the specified routes.
    ///
    /// - Parameter route:
    ///     The route to determine a router for.
    ///
    func router<R: Route>(for route: R) -> AnyRouter<R>?

    ///
    /// This method is called whenever a Presentable is shown to the user.
    /// It further provides information about the context a presentable is shown in.
    ///
    /// - Parameter presentable:
    ///     The context in which the presentable is shown.
    ///     This could be a window, another viewController, a coordinator, etc.
    ///     `nil` is specified whenever a context cannot be easily determined.
    ///
    func presented(from presentable: Presentable?)

    ///
    /// Sets the presentable as the root of the window, makes the window key and visible and calls `presented(from:)` on the presentable.
    ///
    /// - Parameter window:
    ///     The window to set the root of.
    ///
    func setRoot(for window: UIWindow)
}

extension Presentable {

    ///
    /// Sets the presentable as the root of the window.
    ///
    /// This method sets the rootViewController of the window and makes it key and visible.
    /// Furthermore, it calls `presented(from:)` with the window as its parameter.
    ///
    /// - Parameter window:
    ///     The window to set the root of.
    ///
    public func setRoot(for window: UIWindow) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        presented(from: window)
    }

    public func router<R: Route>(for route: R) -> AnyRouter<R>? {
        return self as? AnyRouter<R>
    }

    public func presented(from presentable: Presentable?) {}
}

extension UIViewController: Presentable {}
extension UIWindow: Presentable {}
