//
//  TestAnimation.swift
//  XCoordinator_Tests
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator

class TestAnimation: Animation {
    init(presentation: XCTestExpectation? = nil, dismissal: XCTestExpectation? = nil) {
        super.init(
            presentationAnimation: TestAnimation.presentationAnimation(using: presentation),
            dismissalAnimation: TestAnimation.dismissalAnimation(using: dismissal)
        )
    }

    private static func presentationAnimation(using expectation: XCTestExpectation?) -> TransitionAnimation? {
        return StaticTransitionAnimation(duration: 0) {
            expectation?.fulfill()
            $0.completeTransition(true)
        }
    }

    private static func dismissalAnimation(using expectation: XCTestExpectation?) -> TransitionAnimation? {
        return StaticTransitionAnimation(duration: 0) {
            expectation?.fulfill()
            $0.completeTransition(true)
        }
    }
}
