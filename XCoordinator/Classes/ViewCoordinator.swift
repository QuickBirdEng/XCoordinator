//
//  ViewCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias ViewTransition = Transition<UIViewController>

open class ViewCoordinator<RouteType: Route>: BaseCoordinator<RouteType, ViewTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(root: Presentable) {
        super.init(initialRoute: nil)
        embed(root.viewController, in: rootViewController, with: TransitionOptions(animated: false), completion: nil)
    }
}
