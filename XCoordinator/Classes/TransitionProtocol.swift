//
//  TransitionProtocol.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol TransitionProtocol {
    associatedtype RootViewController: UIViewController

    var presentables: [Presentable] { get }
    var animation: TransitionAnimation? { get }

    func perform<C: Coordinator>(options: TransitionOptions,
                                 coordinator: C,
                                 completion: PresentationHandler?) where C.TransitionType == Self

    // MARK: - Always accessible transitions

    static func present(_ presentable: Presentable, animation: Animation?) -> Self
    static func embed(_ presentable: Presentable, in container: Container) -> Self
    static func dismiss(animation: Animation?) -> Self
    static func none() -> Self
    static func multiple(_ transitions: [Self]) -> Self
}

extension TransitionProtocol {
    public static func multiple(_ transitions: Self...) -> Self {
        return multiple(transitions)
    }
}
