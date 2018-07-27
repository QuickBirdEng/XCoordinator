//
//  NavigationTransitionType.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 27.07.18.
//

internal enum NavigationTransitionType {
    indirect case animated(NavigationTransitionType, animation: Animation)
    case push(Presentable)
    case present(Presentable)
    case embed(presentable: Presentable, container: Container)
    case registerPeek(source: Container, transitionGenerator: () -> NavigationTransition)
    case pop
    case popToRoot
    case dismiss
    case none

    public var presentable: Presentable? {
        switch self {
        case .push(let presentable):
            return presentable
        case .present(let presentable):
            return presentable
        case .embed(let presentable, _):
            return presentable.viewController
        case .registerPeek(_, let popTransition):
            return popTransition().presentable
        case .pop, .popToRoot, .dismiss, .none:
            return nil
        case .animated(let transition, _):
            return transition.presentable
        }
    }

    public func perform<R: Route>(options: TransitionOptions, animation: Animation?, coordinator: AnyCoordinator<R>, completion: PresentationHandler?) where R.TransitionType == NavigationTransition {
        switch self {
        case .animated(let transition, let animation):
            return transition.perform(options: options, animation: animation, coordinator: coordinator, completion: completion)
        case .push(let presentable):
            presentable.presented(from: coordinator)
            return coordinator.push(presentable.viewController, with: options, animation: animation, completion: completion)
        case .present(let presentable):
            presentable.presented(from: coordinator)
            return coordinator.present(presentable.viewController, with: options, animation: animation, completion: completion)
        case .embed(let presentable, let container):
            presentable.presented(from: coordinator)
            return coordinator.embed(presentable.viewController, in: container, with: options, completion: completion)
        case .registerPeek(let source, let transitionGenerator):
            return coordinator.registerPeek(from: source.view, transitionGenerator: transitionGenerator, completion: completion)
        case .pop:
            return coordinator.pop(with: options, toRoot: false, animation: animation, completion: completion)
        case .popToRoot:
            return coordinator.pop(with: options, toRoot: true, animation: animation, completion: completion)
        case .dismiss:
            return coordinator.dismiss(with: options, animation: animation, completion: completion)
        case .none:
            return
        }
    }
}
