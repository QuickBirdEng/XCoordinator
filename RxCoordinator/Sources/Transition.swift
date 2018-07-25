//
//  Transition.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public protocol TransitionType {
    func performTransition<R: Route>(options: TransitionOptions, animation: Animation?,
                                     coordinator: AnyCoordinator<R>, completion: PresentationHandler?)
}

public enum TransitionTypeVC: TransitionType {
    case present(Presentable)
    case embed(presentable: Presentable, container: Container)
    case registerPeek(source: Container, transitionGenerator: () -> ViewTransition)
    case dismiss
    case none

    public func performTransition<R: Route>(options: TransitionOptions, animation: Animation?,
                                            coordinator: AnyCoordinator<R>, completion: PresentationHandler?) {
        switch self {
        case .present(let presentable):
            presentable.presented(from: coordinator)
            return coordinator.present(presentable.viewController, with: options, animation: animation, completion: completion)
        case .embed(let presentable, let container):
            presentable.presented(from: coordinator)
            return coordinator.embed(presentable.viewController, in: container, with: options, completion: completion)
        case .registerPeek(let source, let transitionGenerator):
            return coordinator.registerPeek(from: source.view, transitionGenerator: transitionGenerator, completion: completion)
        case .dismiss:
            return coordinator.dismiss(with: options, animation: animation, completion: completion)
        case .none:
            return
        }
    }
}

public enum TransitionTypeNC: TransitionType {
    case push(Presentable)
    case present(Presentable)
    case embed(presentable: Presentable, container: Container)
    case registerPeek(source: Container, transitionGenerator: () -> NavigationTransition)
    case pop
    case popToRoot
    case dismiss
    case none

    public func performTransition<R: Route>(options: TransitionOptions, animation: Animation?,
                                            coordinator: AnyCoordinator<R>, completion: PresentationHandler?) {
        switch self {
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

public struct Transition<RootType: TransitionType> {
    internal let type: RootType
    internal let animation: Animation?
}

public typealias ViewTransition = Transition<TransitionTypeVC>
public typealias NavigationTransition = Transition<TransitionTypeNC>

extension Transition where RootType == TransitionTypeVC {

    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(type: .present(presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> Transition {
        return Transition(type: .embed(presentable: presentable, container: container), animation: nil)
    }

    public static func registerPeek<R: Route>(from source: Container, route: R, coordinator: AnyCoordinator<R>) -> Transition where R.RootType == TransitionTypeVC {
        return Transition(type: .registerPeek(source: source, transitionGenerator: {
            coordinator.prepareTransition(for: route)
        }), animation: nil)
    }

    public static func dismiss(animation: Animation? = nil) -> Transition {
        return Transition(type: .dismiss, animation: animation)
    }

    public static func none() -> Transition {
        return Transition(type: .none, animation: nil)
    }

}

extension Transition where RootType == TransitionTypeNC {

    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(type: .present(presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> Transition {
        return Transition(type: .embed(presentable: presentable, container: container), animation: nil)
    }

    public static func registerPeek<R: Route>(from source: Container, route: R, coordinator: AnyCoordinator<R>) -> Transition where R.RootType == TransitionTypeNC {
        return Transition(type: .registerPeek(source: source, transitionGenerator: {
            coordinator.prepareTransition(for: route)
        }), animation: nil)
    }

    public static func dismiss(animation: Animation? = nil) -> Transition {
        return Transition(type: .dismiss, animation: animation)
    }

    public static func none() -> Transition {
        return Transition(type: .none, animation: nil)
    }

    public static func push(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(type: .push(presentable), animation: animation)
    }

    public static func pop(animation: Animation? = nil) -> Transition {
        return Transition(type: .pop, animation: animation)
    }

    public static func popToRoot(animation: Animation? = nil) -> Transition {
        return Transition(type: .popToRoot, animation: animation)
    }

}
