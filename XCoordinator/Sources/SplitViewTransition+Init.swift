//
//  SplitViewTransition+Init.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.07.18.
//

extension SplitViewTransition {
    public static func show(_ presentable: Presentable, animation: Animation? = nil) -> SplitViewTransition {
        return SplitViewTransition(type: .show(presentable), animation: animation)
    }

    public static func showDetail(_ presentable: Presentable, animation: Animation? = nil) -> SplitViewTransition {
        return SplitViewTransition(type: .showDetail(presentable), animation: animation)
    }

    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> SplitViewTransition {
        return SplitViewTransition(type: .present(presentable), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> SplitViewTransition {
        return SplitViewTransition(type: .embed(presentable, in: container), animation: nil)
    }

    public static func dismiss(animation: Animation? = nil) -> SplitViewTransition {
        return SplitViewTransition(type: .dismiss, animation: animation)
    }

    public static func none() -> SplitViewTransition {
        return SplitViewTransition(type: .none, animation: nil)
    }
}
