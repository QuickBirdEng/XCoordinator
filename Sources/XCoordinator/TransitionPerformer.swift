//
//  TransitionPerformer.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// The TransitionPerformer protocol is used to abstract the route-type specific characteristics of a Coordinator.
/// It keeps type information about its transition performing capabilities.
///
public protocol TransitionPerformer: Presentable {

    /// The type of transitions that can be executed on the rootViewController.
    associatedtype TransitionType: TransitionProtocol

    /// The rootViewController on which transitions are performed.
    var rootViewController: TransitionType.RootViewController { get }

    ///
    /// Perform a transition.
    ///
    /// - Warning:
    ///     Do not use this method directly, but instead try to use the `trigger`
    ///     method of your coordinator instead wherever possible.
    ///
    /// - Parameters:
    ///     - transition: The transition to be performed.
    ///     - options: The options on how to perform the transition, including the option to enable/disable animations.
    ///     - completion: The completion handler called once a transition has finished.
    ///
    func performTransition(_ transition: TransitionType,
                           with options: TransitionOptions,
                           completion: PresentationHandler?)

}
