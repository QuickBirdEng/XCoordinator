//
//  TabBarCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 29.07.18.
//

import Foundation

open class TabBarCoordinator<R: Route>: BaseCoordinator<R, TabBarTransition> {

    // MARK: - Init

    public convenience init(tabs: [Presentable]) {
        self.init(initialRoute: nil)
        performTransition(.set(tabs), with: TransitionOptions(animated: false))
    }

    public convenience init(tabs: [Presentable], select: Presentable) {
        self.init(initialRoute: nil)
        performTransition(.set(tabs), with: TransitionOptions(animated: false), completion: {
            self.performTransition(.select(select), with: TransitionOptions(animated: false))
        })
    }

    public convenience init(tabs: [Presentable], select: Int) {
        self.init(initialRoute: nil)
        performTransition(.set(tabs), with: TransitionOptions(animated: false), completion: {
            self.performTransition(.select(index: select), with: TransitionOptions(animated: false))
        })
    }
}
