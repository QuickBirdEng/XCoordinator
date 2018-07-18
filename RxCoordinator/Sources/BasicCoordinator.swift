//
//  BasicCoordinator.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation

open class BasicCoordinator<BasicRoute: Route>: Coordinator {
    public typealias CoordinatorRoute = BasicRoute

    public enum InitalLoadingType {
        case immediately
        case presented
    }

    public var context: UIViewController!
    public var rootViewController: UIViewController {
        get {
            return rootVCReferenceBox.get()!
        }
        set {
            rootVCReferenceBox.set(newValue)
        }
    }

    private let initialRoute: BasicRoute?
    private let initialLoadingType: InitalLoadingType
    private let rootVCReferenceBox = ReferenceBox<UIViewController>()

    public init(initialRoute: BasicRoute? = nil, initialLoadingType: InitalLoadingType = .presented) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.rootVCReferenceBox.set(UINavigationController())

        if let initialRoute = initialRoute, initialLoadingType == .immediately {
            transition(to: initialRoute)
        }
    }

    open func presented(from presentable: Presentable?) {
        context = presentable?.viewController

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            transition(to: initialRoute)
        }

        rootVCReferenceBox.releaseStrongReference()
    }

    public func transition(to route: BasicRoute, with options: TransitionOptions) -> TransitionObservables {
        let transition = route.prepareTransition(coordinator: AnyCoordinator(self))

        switch transition.type {
        case let transitionType as TransitionTypeVC:
            switch transitionType {
            case .present(let presentable):
                presentable.presented(from: self)
                return present(presentable.viewController, with: options, animation: transition.animation)
            case .embed(let presentable, let container):
                presentable.presented(from: self)
                return embed(presentable.viewController, in: container, with: options)
            case .dismiss:
                return dismiss(with: options, animation: transition.animation)
            case .none:
                return TransitionObservables(presentation: .empty(), dismissal: .empty())
            }
        case let transitionType as TransitionTypeNC:
            switch transitionType {
            case .push(let presentable):
                presentable.presented(from: self)
                return push(presentable.viewController, with: options, animation: transition.animation)
            case .present(let presentable):
                presentable.presented(from: self)
                return present(presentable.viewController, with: options, animation: transition.animation)
            case .embed(let presentable, let container):
                presentable.presented(from: self)
                return embed(presentable.viewController, in: container, with: options)
            case .pop:
                return pop(with: options, toRoot: false, animation: transition.animation)
            case .popToRoot:
                return pop(with: options, toRoot: true, animation: transition.animation)
            case .dismiss:
                return dismiss(with: options, animation: transition.animation)
            case .none:
                return TransitionObservables(presentation: .empty(), dismissal: .empty())
            }
        default:
            return TransitionObservables(presentation: .empty(), dismissal: .empty())
        }
    }

}
