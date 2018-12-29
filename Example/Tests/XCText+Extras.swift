//
//  XCText+Extras.swift
//  XCoordinator_Tests
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest

extension XCTestCase {
    func asyncWait(for timeInterval: TimeInterval) {
        let waitExpectation = self.expectation(description: "WAIT \(Date().timeIntervalSince1970)")
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + timeInterval) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: max(timeInterval * 2, 1))
    }
}
