//
//  TabBarCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class TabBarCoordinator<R: Route>: BaseCoordinator<R, TabBarTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }

    public init(tabs: [Presentable]) {
        super.init(initialTransition: .set(tabs), completion: nil)
    }

    public init(tabs: [Presentable], select: Presentable) {
        super.init(initialTransition: .multiple(.set(tabs), .select(select)))
    }

    public init(tabs: [Presentable], select: Int) {
        super.init(initialTransition: .multiple(.set(tabs), .select(index: select)))
    }
}
