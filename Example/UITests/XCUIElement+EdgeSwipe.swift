//
//  XCUIElement+EdgeSwipe.swift
//  XCoordinator_UITests
//
//  Created by Paul Kraft on 05.03.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import XCTest

extension XCUIElement {
    func edgeSwipeLeft() {
        let firstCoordinate = coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0.5))
        let secondCoordinate = coordinate(withNormalizedOffset: CGVector(dx: 0.6, dy: 0.5))
        firstCoordinate.press(forDuration: 0.01, thenDragTo: secondCoordinate)
    }

    func edgeSwipeRight() {
        let firstCoordinate = coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 0.5))
        let secondCoordinate = coordinate(withNormalizedOffset: CGVector(dx: 0.4, dy: 0.5))
        firstCoordinate.press(forDuration: 0.01, thenDragTo: secondCoordinate)
    }
}
