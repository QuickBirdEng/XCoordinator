//
//  PageViewTransitionType.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

enum PageViewTransitionType {
    indirect case animated(PageViewTransitionType, animation: Animation)
    case present(Presentable)
    case embed(Presentable, `in`: Container)
    case set([Presentable], direction: UIPageViewControllerNavigationDirection)
    case dismiss
    case none
    case multiple([PageViewTransitionType])

    var presentable: Presentable? {
        switch self {
        case .present(let presentable):
            return presentable
        case .embed(let presentable, _):
            return presentable
        case .dismiss, .none, .set, .multiple:
            return nil
        case .animated(let transition, _):
            return transition.presentable
        }
    }

    public func perform<C: Coordinator>(options: TransitionOptions, animation: Animation?, coordinator: C, completion: PresentationHandler?) where PageViewTransition == C.TransitionType {
        switch self {
        case .multiple(let transitions):
            guard let firstTransition = transitions.first else {
                completion?()
                return
            }
            firstTransition.perform(options: options, animation: animation, coordinator: coordinator) {
                let newTransitions = Array(transitions.dropFirst())
                coordinator.performTransition(.multiple(newTransitions), with: options, completion: completion)
            }
        case .set(let presentables, let direction):
            return coordinator.set(presentables.map { $0.viewController }, direction: direction, with: options, animation: animation, completion: completion)
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
            completion?()
            return
        }
    }
}
