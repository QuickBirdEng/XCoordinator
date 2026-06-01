//
//  TransitionSwiftUITests.swift
//  XCoordinatorTests
//
//  Verifies Transition.withAnimation / withTransaction run their body and call completion.
//

import SwiftUI
import UIKit
import XCoordinator
import XCTest

@MainActor
final class TransitionSwiftUITests: XCTestCase {

    func testWithAnimationRunsBodyAndCompletes() {
        var bodyRan = false
        let completed = expectation(description: "completion")
        let transition = Transition<UIViewController>.withAnimation { bodyRan = true }
        transition.perform(on: UIViewController(), with: .init(animated: true)) {
            completed.fulfill()
        }
        wait(for: [completed], timeout: 3)
        XCTAssertTrue(bodyRan)
    }

    func testWithAnimationCompletesWhenNotAnimated() {
        var bodyRan = false
        let completed = expectation(description: "completion")
        let transition = Transition<UIViewController>.withAnimation { bodyRan = true }
        transition.perform(on: UIViewController(), with: .init(animated: false)) {
            completed.fulfill()
        }
        wait(for: [completed], timeout: 3)
        XCTAssertTrue(bodyRan)
    }

    func testWithTransactionRunsBodyAndCompletes() {
        var bodyRan = false
        let completed = expectation(description: "completion")
        let transition = Transition<UIViewController>.withTransaction(Transaction()) { bodyRan = true }
        transition.perform(on: UIViewController(), with: .init(animated: true)) {
            completed.fulfill()
        }
        wait(for: [completed], timeout: 3)
        XCTAssertTrue(bodyRan)
    }

    func testWithAnimationHasNoPresentables() {
        let transition = Transition<UIViewController>.withAnimation { }
        XCTAssertTrue(transition.presentables.isEmpty)
    }
}
