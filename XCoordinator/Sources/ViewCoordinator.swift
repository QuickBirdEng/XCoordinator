//
//  ViewCoordinator.swift
//  rx-coordinator
//
//  Created by Paul Kraft on 29.07.18.
//

open class ViewCoordinator<R: Route>: BaseCoordinator<R, ViewTransition> {

    // MARK: - Init

    public override init(initialRoute: RouteType?) {
        super.init(initialRoute: initialRoute)
    }
}
