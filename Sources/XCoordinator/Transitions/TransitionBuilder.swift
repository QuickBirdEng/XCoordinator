//
//  TransitionBuilder.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// A result builder that assembles a single ``Transition`` from one or more `Transition` values.
///
/// Use it to describe a coordinator's transitions inline — e.g. in `prepareTransition(for:)` or a
/// `BasicCoordinator`'s `prepare` closure — by listing the `Transition.…` factories that apply to the
/// coordinator's root view controller:
///
/// ```swift
/// override func prepareTransition(for route: AppRoute) -> NavigationTransition {
///     switch route {
///     case .home:           Transition.push(HomeViewController())
///     case .detail(let id): Transition.push(DetailViewController(id: id))
///     case .ignored:        Transition.none()
///     }
/// }
/// ```
///
/// Multiple statements are chained with ``Transition/multiple(_:)-(some Collection<Transition>)`` and
/// performed strictly in order. An empty builder block is a compile-time error — use ``Transition/none()``
/// to express an intentional no-op.
///
@MainActor
@resultBuilder
public enum TransitionBuilder<RootViewController: UIViewController> {

    public static func buildExpression(_ expression: Transition<RootViewController>) -> Transition<RootViewController> {
        expression
    }

    public static func buildExpression(_ expression: Never) -> Transition<RootViewController> {}

    public static func buildEither(first component: Transition<RootViewController>) -> Transition<RootViewController> {
        component
    }

    public static func buildEither(second component: Transition<RootViewController>) -> Transition<RootViewController> {
        component
    }

    public static func buildOptional(_ component: Transition<RootViewController>?) -> Transition<RootViewController> {
        component ?? .none()
    }

    public static func buildLimitedAvailability(_ component: Transition<RootViewController>) -> Transition<RootViewController> {
        component
    }

    public static func buildBlock(
        _ first: Transition<RootViewController>,
        _ rest: Transition<RootViewController>...
    ) -> Transition<RootViewController> {
        rest.isEmpty ? first : .multiple([first] + rest)
    }

    public static func buildArray(_ components: [Transition<RootViewController>]) -> Transition<RootViewController> {
        .multiple(components)
    }

    public static func buildFinalResult(_ component: Transition<RootViewController>) -> Transition<RootViewController> {
        component
    }

}
