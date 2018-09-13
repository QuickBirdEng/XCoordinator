//
//  TransitionPerformer.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//

public protocol TransitionPerformer: Presentable {
    associatedtype TransitionType: TransitionProtocol

    var rootViewController: TransitionType.RootViewController { get }
}
