//
//  NavigationCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 29.07.18.
//

import Foundation

open class NavigationCoordinator<R: Route>: BaseCoordinator<R, NavigationTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(root: Presentable) {
        super.init(initialRoute: nil)
        performTransition(.push(root), with: TransitionOptions(animated: false))
    }
}
