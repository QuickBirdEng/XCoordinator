//
//  TriggerModifierTests.swift
//  XCoordinatorTests
//
//  Verifies the declarative trigger view modifiers fire (and skip the initial value) as documented.
//

import SwiftUI
import UIKit
import XCoordinator
import XCTest

/// A coordinator that records the routes triggered on it (returning a no-op transition).
@MainActor
private final class RecordingCoordinator: ViewCoordinator<TestRoute> {

    private(set) var triggered: [TestRoute] = []
    var onTrigger: (() -> Void)?

    init() {
        super.init(rootViewController: UIViewController())
    }

    override func prepareTransition(for route: TestRoute) -> ViewTransition {
        triggered.append(route)
        onTrigger?()
        return .none()
    }
}

@MainActor
private final class Model: ObservableObject {
    @Published var value = 0
}

@MainActor
final class TriggerModifierTests: XCTestCase {

    lazy var window = makeWindow()

    private func host<Content: View>(_ view: Content) {
        window.rootViewController = UIHostingController(rootView: view)
        window.makeKeyAndVisible()
    }

    /// `triggerOnAppear` must fire exactly once when the view appears. (Regression for the inverted guard.)
    func testTriggerOnAppearFiresOnce() {
        let coordinator = RecordingCoordinator()
        // No `assertForOverFulfill = false`: triggerOnAppear must fire exactly once, so a second
        // fulfillment should fail the test (it would mean the route fired more than once).
        let fired = expectation(description: "fired")
        coordinator.onTrigger = { fired.fulfill() }

        host(
            Color.clear
                .triggerOnAppear(route: TestRoute.home)
                .router(coordinator)
        )

        wait(for: [fired], timeout: 5)
        asyncWait(for: 0.2)
        XCTAssertEqual(coordinator.triggered, [.home])
    }

    /// `triggerOnChange(of:)` must skip the initial value and fire when the value changes.
    func testTriggerOnChangeSkipsInitialThenFires() {
        let coordinator = RecordingCoordinator()
        let model = Model()

        struct Probe: View {
            @ObservedObject var model: Model
            let coordinator: RecordingCoordinator
            var body: some View {
                Color.clear
                    .triggerOnChange(of: model.value, route: TestRoute.home)
                    .router(coordinator)
            }
        }

        host(Probe(model: model, coordinator: coordinator))
        asyncWait(for: 0.3)
        XCTAssertEqual(coordinator.triggered, [], "triggerOnChange must skip the initial value")

        let fired = expectation(description: "fired")
        coordinator.onTrigger = { fired.fulfill() }
        model.value = 1
        wait(for: [fired], timeout: 5)
        XCTAssertEqual(coordinator.triggered, [.home])
    }

    /// `trigger(when:)` must fire only when the condition transitions to `true`.
    func testTriggerWhenFiresOnFalseToTrue() {
        let coordinator = RecordingCoordinator()
        let model = Model() // value 0 => condition false

        struct Probe: View {
            @ObservedObject var model: Model
            let coordinator: RecordingCoordinator
            var body: some View {
                Color.clear
                    .trigger(when: model.value == 1, route: TestRoute.home)
                    .router(coordinator)
            }
        }

        host(Probe(model: model, coordinator: coordinator))
        asyncWait(for: 0.3)
        XCTAssertEqual(coordinator.triggered, [], "should not fire while the condition is false")

        let fired = expectation(description: "fired")
        coordinator.onTrigger = { fired.fulfill() }
        model.value = 1
        wait(for: [fired], timeout: 5)
        XCTAssertEqual(coordinator.triggered, [.home])
    }
}
