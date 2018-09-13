//
//  NavigationCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 29.07.18.
//

open class NavigationCoordinator<R: Route>: BaseCoordinator<R, NavigationTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType? = nil) {
        super.init(initialRoute: initialRoute)
    }

    public init(root: Presentable) {
        super.init(initialTransition: .push(root))
    }
}
