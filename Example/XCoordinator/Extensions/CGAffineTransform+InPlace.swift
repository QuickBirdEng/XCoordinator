//
//  CGAffineTransform+InPlace.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension CGAffineTransform {
    mutating func rotate(by rotationAngle: CGFloat) {
        self = self.rotated(by: rotationAngle)
    }

    mutating func scale(by scalingFactor: CGFloat) {
        self = self.scaledBy(x: scalingFactor, y: scalingFactor)
    }
}
