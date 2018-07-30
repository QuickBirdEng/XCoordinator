//
//  Transition.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public protocol Transition {
    associatedtype RootViewController: UIViewController

    var presentable: Presentable? { get }
    func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where C.TransitionType == Self

    static func generateRootViewController() -> RootViewController

    // MARK: - Always accessible transitions

    static func present(_ presentable: Presentable, animation: Animation?) -> Self
    static func embed(_ presentable: Presentable, in container: Container) -> Self
    static func dismiss(animation: Animation?) -> Self
    static func none() -> Self
    static func multiple(_ transitions: [Self], completion: PresentationHandler?) -> Self
}

extension Transition {
    public static func multiple(_ transitions: Self..., completion: PresentationHandler?) -> Self {
        return multiple(transitions, completion: completion)
    }
}
