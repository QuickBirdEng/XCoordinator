//
//  SplitViewTransitionType.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

enum SplitViewTransitionType {
    indirect case animated(SplitViewTransitionType, animation: Animation)
    case present(Presentable)
    case embed(Presentable, `in`: Container)
    case show(Presentable)
    case showDetail(Presentable)
    case dismiss
    case none

    var presentable: Presentable? {
        switch self {
        case .present(let presentable):
            return presentable
        case .embed(let presentable, _):
            return presentable
        case .dismiss, .none:
            return nil
        case .show(let presentable):
            return presentable
        case .showDetail(let presentable):
            return presentable
        case .animated(let transition, _):
            return transition.presentable
        }
    }

    public func perform<C: Coordinator>(options: TransitionOptions, animation: Animation?, coordinator: C, completion: PresentationHandler?) where SplitViewTransition == C.TransitionType {
        switch self {
        case .animated(let transition, let animation):
            return transition.perform(options: options, animation: animation, coordinator: coordinator, completion: completion)
        case .present(let presentable):
            presentable.presented(from: coordinator)
            return coordinator.present(presentable.viewController, with: options, animation: animation, completion: completion)
        case .embed(let presentable, let container):
            presentable.presented(from: coordinator)
            return coordinator.embed(presentable.viewController, in: container, with: options, completion: completion)
        case .dismiss:
            return coordinator.dismiss(with: options, animation: animation, completion: completion)
        case .none:
            return
        case .show(let presentable):
            presentable.presented(from: coordinator)
            return coordinator.show(presentable.viewController, with: options, animation: animation, completion: completion)
        case .showDetail(let presentable):
            presentable.presented(from: coordinator)
            return coordinator.showDetail(presentable.viewController, with: options, animation: animation, completion: completion)
        }
    }
}
