//
//  TransitionOptions.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// TransitionOptions specifies transition customization points defined at the point of triggering a transition.
///
/// You can use TransitionOptions to define whether or not a transition should be animated.
/// It might be extended in the future to enable more advanced customization options.
///
public struct TransitionOptions {

    // MARK: - Stored properties

    /// Specifies whether or not the transition should be animated.
    public let animated: Bool

    // MARK: - Initialization

    ///
    /// Creates transition options on the basis of whether or not it should be animated.
    ///
    /// - Parameter animated:
    ///     Whether or not the animation should be animated.
    ///     Specifying `true` does not necessarily lead to an animated transition, if the transition does not support it.
    ///
    public init(animated: Bool) {
        self.animated = animated
    }

    // MARK: - Static computed properties

    static var `default`: TransitionOptions {
        return TransitionOptions(animated: true)
    }
}
