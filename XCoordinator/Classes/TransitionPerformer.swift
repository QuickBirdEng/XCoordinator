//
//  TransitionPerformer.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// The TransitionPerformer protocol is used to abstract away from the router capabilities of a coordinator and instead focusing on its
/// rootViewController type and transition performing capabilities.
///
public protocol TransitionPerformer: Presentable {

    /// The type of transitions that can be executed on the rootViewController.
    associatedtype TransitionType: TransitionProtocol

    /// The rootViewController on which transitions are performed.
    var rootViewController: TransitionType.RootViewController { get }

    ///
    /// Perform a transition.
    ///
    /// - Note:
    ///     We advise against the use of this method directly.
    ///     Try to use the `trigger` method of your coordinator instead wherever possible.
    ///
    /// - Parameter transition:
    ///     The transition to be performed.
    ///
    /// - Parameter options:
    ///     The options on how to perform the transition.
    ///
    /// - Parameter completion:
    ///     The completion handler called once a transition has finished.
    ///
    func performTransition(_ transition: TransitionType,
                           with options: TransitionOptions,
                           completion: PresentationHandler?)
}
