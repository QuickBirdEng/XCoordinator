//
//  TabBarTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public typealias TabBarTransition = Transition<UITabBarController>

extension Transition where RootViewController: UITabBarController {

    ///
    /// Transition to set the tabs of the rootViewController with an optional custom animation.
    ///
    /// - Parameter presentables:
    ///     The tabs to be set are defined by the presentables' viewControllers.
    ///
    /// - Parameter animation:
    ///     The animation to be used. If you specify `nil` here, the default animation by UIKit is used.
    ///     Only the presentation animation of the Animation object is used.
    ///
    public static func set(_ presentables: [Presentable], animation: Animation? = nil) -> Transition {
        return Transition(presentables: presentables,
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.set(presentables.map { $0.viewController },
                          with: options,
                          animation: animation,
                          completion: {
                            presentables.forEach { $0.presented(from: performer) }
                            completion?()
            })
        }
    }

    ///
    /// Transition to select a tab with an optional custom animation.
    ///
    /// - Parameter presentable:
    ///     The tab to be selected is the presentable's viewController. Make sure that this is one of the
    ///     previously specified tabs of the rootViewController.
    ///
    /// - Parameter animation:
    ///     The animation to be used. If you specify `nil` here, the default animation by UIKit is used.
    ///     Only the presentation animation of the Animation object is used.
    ///
    public static func select(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(presentables: [presentable],
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.select(presentable.viewController,
                             with: options,
                             animation: animation,
                             completion: completion)
        }
    }

    ///
    /// Transition to select a tab with an optional custom animation.
    ///
    /// - Parameter index:
    ///     The index of the tab to be selected. Make sure that there is a tab at the specified index.
    ///
    /// - Parameter animation:
    ///     The animation to be used. If you specify `nil` here, the default animation by UIKit is used.
    ///     Only the presentation animation of the Animation object is used.
    ///
    public static func select(index: Int, animation: Animation? = nil) -> Transition {
        return Transition(presentables: [],
                          animation: animation?.presentationAnimation
        ) { options, performer, completion in
            performer.select(index: index,
                             with: options,
                             animation: animation,
                             completion: completion)
        }
    }
}
