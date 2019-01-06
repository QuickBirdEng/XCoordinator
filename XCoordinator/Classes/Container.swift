//
//  Container.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// Container abstracts away from the difference of `UIView` and `UIViewController`
///
/// With the Container protocol, `UIView` and `UIViewController` objects can be used interchangeably,
/// e.g. when embedding containers into containers.
///
public protocol Container {

    ///
    /// The view of a Container.
    ///
    /// It might not exist for a `UIViewController`.
    ///
    var view: UIView! { get }

    ///
    /// The viewController of a Container.
    ///
    /// It might not exist for a `UIView`.
    ///
    var viewController: UIViewController! { get }
}

// MARK: - Extensions

extension UIViewController: Container {
    public var viewController: UIViewController! { return self }
}

extension UIView: Container {
    public var viewController: UIViewController! {
        return viewController(for: self)
    }

    public var view: UIView! { return self }
}

extension UIView {
    private func viewController(for responder: UIResponder) -> UIViewController? {
        if let viewController = responder as? UIViewController {
            return viewController
        }

        if let nextResponser = responder.next {
            return viewController(for: nextResponser)
        }

        return nil
    }
}
