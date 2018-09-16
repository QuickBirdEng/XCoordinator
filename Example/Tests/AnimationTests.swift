//
//  AnimationTests.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest
@testable import XCoordinator

class AnimationTests: XCTestCase {

    func testSplitAnimations() {
        let window = UIWindow()
        let master = UIViewController()
        let detail = UIViewController()
        let coordinator = PageCoordinator<TestRoute>(pages: [master, detail])
        coordinator.setRoot(for: window)

        let newVC = UIViewController()
        let presentation = expectation(description: "presentation")
        coordinator.performTransition(
            .set([newVC], direction: .forward),
            with: .default)
        waitForExpectations(timeout: 0.2, handler: nil)
    }

}
