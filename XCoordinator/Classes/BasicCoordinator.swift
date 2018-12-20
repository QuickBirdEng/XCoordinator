//
//  BasicCoordinator.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 05.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias BasicNavigationCoordinator<R: Route> = BasicCoordinator<R, NavigationTransition>
public typealias BasicViewCoordinator<R: Route> = BasicCoordinator<R, ViewTransition>
public typealias BasicTabBarCoordinator<R: Route> = BasicCoordinator<R, TabBarTransition>

open class BasicCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: BaseCoordinator<RouteType, TransitionType> {

    // MARK: - Nested types

    public enum InitialLoadingType {
        case immediately
        case presented
    }

    // MARK: - Stored properties

    private let initialRoute: RouteType?
    private let initialLoadingType: InitialLoadingType
    private let prepareTransition: ((RouteType) -> TransitionType)?

    // MARK: - Init

    public init(initialRoute: RouteType? = nil,
                initialLoadingType: InitialLoadingType = .presented,
                prepareTransition: ((RouteType) -> TransitionType)?) {
        self.initialRoute = initialRoute
        self.initialLoadingType = initialLoadingType
        self.prepareTransition = prepareTransition

        if let initialRoute = initialRoute, initialLoadingType == .immediately {
            super.init(initialRoute: initialRoute)
        } else {
            super.init(initialRoute: nil)
        }
    }

    // MARK: - Open methods

    open override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)

        if let initialRoute = initialRoute, initialLoadingType == .presented {
            trigger(initialRoute, with: TransitionOptions(animated: false), completion: nil)
        }
    }

    open override func prepareTransition(for route: RouteType) -> TransitionType {
        if let prepareTransition = prepareTransition {
            return prepareTransition(route)
        } else {
            fatalError("Either pass a \(#function) closure to the initializer or override this method.")
        }
    }
}
