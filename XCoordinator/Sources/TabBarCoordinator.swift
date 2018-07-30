//
//  TabBarCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 29.07.18.
//

import Foundation

open class TabBarCoordinator<R: Route>: BaseCoordinator<R, TabBarTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(tabs: [Presentable]) {
        super.init(initialTransition: .set(tabs), completion: nil)
    }

    public init(tabs: [Presentable], select: Presentable) {
        super.init(initialTransition: .multiple(.set(tabs), .select(select), completion: nil))
    }

    public init(tabs: [Presentable], select: Int) {
        super.init(initialTransition: .multiple(.set(tabs), .select(index: select), completion: nil))
    }
}
