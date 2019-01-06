//
//  TransitionPerformer.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

public protocol TransitionPerformer: Presentable {
    associatedtype TransitionType: TransitionProtocol

    var rootViewController: TransitionType.RootViewController { get }

    func performTransition(_ transition: TransitionType,
                           with options: TransitionOptions,
                           completion: PresentationHandler?)
}
