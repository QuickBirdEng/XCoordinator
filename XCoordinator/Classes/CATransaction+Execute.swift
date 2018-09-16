//
//  CATransaction+Execute.swift
//  XCoordinator
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

extension CATransaction {
    internal static func execute(_ transaction: () -> Void, completion: (() -> Void)?) {
        begin()
        setCompletionBlock(completion ?? {})
        transaction()
        commit()
    }

    internal static func empty(completion: @escaping () -> Void) {
        execute({}, completion: completion)
    }
}
