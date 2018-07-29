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
        super.init(initialRoute: nil)
        performTransition(.set(tabs), with: TransitionOptions(animated: false))
    }

    public init(tabs: [Presentable], select: Presentable) {
        super.init(initialRoute: nil)
        performTransition(.set(tabs), with: TransitionOptions(animated: false), completion: {
            self.performTransition(.select(select), with: TransitionOptions(animated: false))
        })
    }

    public init(tabs: [Presentable], select: Int) {
        super.init(initialRoute: nil)
        performTransition(.set(tabs), with: TransitionOptions(animated: false), completion: {
            self.performTransition(.select(index: select), with: TransitionOptions(animated: false))
        })
    }
}
