//
//  TabBarTransitionType.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//

import Foundation

internal enum TabBarTransitionType {
    indirect case animated(TabBarTransitionType, animation: Animation)
    case set(presentables: [Presentable])
    case select(presentable: Presentable)
    case present(presentable: Presentable)
    case embed(presentable: Presentable, container: Container)
    case selectIndex(Int)
    case dismiss
    case none

    // MARK: - Computed properties

    var presentable: Presentable? {
        switch self {
        case .present(let presentable):
            return presentable
        case .embed(let presentable, _):
            return presentable
        case .animated(let type, _):
            return type.presentable
        case .select(let presentable):
            return presentable
        case .dismiss, .set, .none, .selectIndex:
            return nil
        }
    }

    // MARK: - Methods

    public func perform<C: Coordinator>(options: TransitionOptions, animation: Animation?, coordinator: C, completion: PresentationHandler?) where TabBarTransition == C.TransitionType {
        switch self {
        case .animated(let type, let animation):
            return type.perform(options: options, animation: animation, coordinator: coordinator, completion: completion)
        case .select(let presentable):
            return coordinator.select(presentable.viewController, with: options, animation: animation, completion: completion)
        case .selectIndex(let index):
            return coordinator.select(index: index, with: options, animation: animation, completion: completion)
        case .set(let presentables):
            return coordinator.set(presentables.map { $0.viewController }, with: options, animation: animation, completion: completion)
        case .dismiss:
            return coordinator.dismiss(with: options, animation: animation, completion: completion)
        case .none:
            return
        case .present(let presentable):
            return coordinator.present(presentable.viewController, with: options, animation: animation, completion: completion)
        case .embed(let presentable, let container):
            return coordinator.embed(presentable.viewController, in: container, with: options, completion: completion)
        }
    }
}
