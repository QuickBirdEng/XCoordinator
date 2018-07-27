//
//  Route.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation

public protocol Route {
    associatedtype TransitionType: Transition
}

public protocol NavigationRoute: Route where Self.TransitionType == NavigationTransition {}
public protocol ViewRoute: Route where Self.TransitionType == ViewTransition {}
