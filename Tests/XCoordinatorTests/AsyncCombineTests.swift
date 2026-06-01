//
//  AsyncCombineTests.swift
//  XCoordinatorTests
//
//  Verifies async trigger, the continuation once-guard, and lazy Combine publishers.
//

import Combine
import UIKit
import XCoordinator
import XCTest

/// Records how many times `prepareTransition` runs and performs a no-op transition.
@MainActor
private final class NoopCoordinator: ViewCoordinator<TestRoute> {

    private(set) var prepareCount = 0

    init() {
        super.init(rootViewController: UIViewController())
    }

    override func prepareTransition(for route: TestRoute) -> ViewTransition {
        prepareCount += 1
        return .none()
    }
}

/// Returns a transition whose perform closure invokes its completion twice.
@MainActor
private final class DoubleCompletionCoordinator: ViewCoordinator<TestRoute> {

    init() {
        super.init(rootViewController: UIViewController())
    }

    override func prepareTransition(for route: TestRoute) -> ViewTransition {
        Transition(presentables: [], animationInUse: nil) { _, _, completion in
            completion?()
            completion?()
        }
    }
}

@MainActor
final class AsyncCombineTests: XCTestCase {

    func testAsyncTriggerCompletes() async {
        let coordinator = NoopCoordinator()
        await coordinator.trigger(.home)
        XCTAssertEqual(coordinator.prepareCount, 1)
    }

    /// A transition that fires its completion twice must not crash the awaiting continuation.
    func testAsyncTriggerSurvivesDoubleCompletion() async {
        let coordinator = DoubleCompletionCoordinator()
        _ = await coordinator.contextTrigger(.home, with: .init(animated: false))
    }

    /// `router.publishers.trigger` must be lazy: no transition until a subscriber attaches.
    func testCombinePublisherIsLazy() {
        let coordinator = NoopCoordinator()
        let publisher = coordinator.publishers.trigger(.home)
        XCTAssertEqual(coordinator.prepareCount, 0,
                       "the publisher must not perform the transition before subscription")

        let completed = expectation(description: "completed")
        let cancellable = publisher.sink { _ in completed.fulfill() }
        wait(for: [completed], timeout: 3)
        XCTAssertEqual(coordinator.prepareCount, 1)
        _ = cancellable
    }
}
