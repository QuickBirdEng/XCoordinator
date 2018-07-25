//
//  TransitionOptions.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation

public struct TransitionOptions {
    let animated: Bool

    public init(animated: Bool) {
        self.animated = animated
    }

    static var `default`: TransitionOptions {
        return TransitionOptions(animated: true)
    }
}
