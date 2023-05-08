//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

@resultBuilder
public enum TransitionBuilder<RootViewController: UIViewController> {

    public typealias Component = TransitionGroup<RootViewController>

    public static func buildExpression(_ expression: some TransitionComponent<RootViewController>) -> Component {
        TransitionGroup([expression.build])
    }

    public static func buildExpression(_ expression: Void) -> Component {
        TransitionGroup([])
    }

    public static func buildExpression(_ expression: Never) -> Component {}

    public static func buildEither(first component: Component) -> Component {
        component
    }

    public static func buildEither(second component: Component) -> Component {
        component
    }

    public static func buildOptional(_ component: Component?) -> Component {
        buildArray([component].compactMap { $0 })
    }

    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }

    public static func buildBlock(_ components: Component...) -> Component {
        buildArray(components)
    }

    public static func buildArray(_ components: [Component]) -> Component {
        TransitionGroup(components.map { $0.build })
    }

    public static func buildFinalResult(_ component: Component) -> Transition<RootViewController> {
        component.build()
    }

}

