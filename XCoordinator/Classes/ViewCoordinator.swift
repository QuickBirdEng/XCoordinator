//
//  ViewCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class ViewCoordinator<R: Route>: BaseCoordinator<R, ViewTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }
}
