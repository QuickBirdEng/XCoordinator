//
//  SplitCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

open class SplitCoordinator<RouteType: Route>: BaseCoordinator<RouteType, SplitTransition> {

    // MARK: - Init

    public init(master: Presentable, detail: Presentable) {
        super.init(initialRoute: nil)
        rootViewController.viewControllers = [master.viewController, detail.viewController]
    }
}
