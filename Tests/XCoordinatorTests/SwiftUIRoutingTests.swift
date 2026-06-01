//
//  SwiftUIRoutingTests.swift
//  XCoordinatorTests
//
//  Verifies that the SwiftUI routing context propagates so `@Routing` resolves.
//

import SwiftUI
import UIKit
import XCoordinator
import XCTest

/// A SwiftUI view that resolves `@Routing<R>` from the environment and reports the result.
///
/// Uses the projected value's subscript (rather than `wrappedValue`) so a missing router reports
/// `nil` instead of triggering the `fatalError` in `Routing.wrappedValue`. Reports both on appear and
/// whenever the injected routing context changes, so it catches routers that are merged in after the
/// first render. Callers latch on the first non-nil resolution.
private struct RouterProbeView<R: Route>: View {

    @Routing<R> private var router
    let onResolve: (AnyObject) -> Void

    var body: some View {
        Color.clear
            .onAppear { report() }
            .onChange(of: $router) { _ in report() }
    }

    private func report() {
        if let resolved = $router[R.self] {
            onResolve(resolved as AnyObject)
        }
    }
}

@MainActor
final class SwiftUIRoutingTests: XCTestCase {

    lazy var window = makeWindow()

    /// `RoutingController` pushed from a UIKit coordinator must inject that coordinator so a
    /// descendant `@Routing<TestRoute>` resolves to it. (Regression for the snapshot-capture bug.)
    func testRoutingControllerResolvesPushingCoordinator() {
        let resolved = expectation(description: "resolved")
        var resolvedRouter: AnyObject?
        var didResolve = false

        let coordinator = BasicNavigationCoordinator<TestRoute>(
            rootViewController: .init()
        ) { route in
            switch route {
            case .home:
                Transition.push(RoutingController {
                    RouterProbeView<TestRoute> { router in
                        guard !didResolve else { return }
                        didResolve = true
                        resolvedRouter = router
                        resolved.fulfill()
                    }
                })
            }
        }
        coordinator.setRoot(for: window)
        coordinator.trigger(.home)

        wait(for: [resolved], timeout: 5)
        XCTAssertTrue(resolvedRouter === coordinator,
                      "@Routing<TestRoute> should resolve to the pushing coordinator")
    }

    /// `ViewCoordinator(body:)` hosts its SwiftUI content in a `RoutingController`; the coordinator
    /// registers itself, so `@Routing<TestRoute>` in the body resolves to it.
    func testViewCoordinatorBodyResolvesItself() {
        let resolved = expectation(description: "resolved")
        var resolvedRouter: AnyObject?
        var didResolve = false

        let coordinator = ViewCoordinator<TestRoute>(body: {
            RouterProbeView<TestRoute> { router in
                guard !didResolve else { return }
                didResolve = true
                resolvedRouter = router
                resolved.fulfill()
            }
        })
        coordinator.setRoot(for: window)

        wait(for: [resolved], timeout: 5)
        XCTAssertTrue(resolvedRouter === coordinator)
    }

    /// A `WrappedRouter` publishes its router upward via the `PreferenceKey`; the hosting
    /// `RoutingController` must merge it into its own context (the `onUpdate` path).
    func testWrappedRouterPropagatesToHostContext() {
        let embedded = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        let host = RoutingController {
            WrappedRouter { embedded }
        }
        window.rootViewController = host
        window.makeKeyAndVisible()

        asyncWait(for: 0.5)

        let resolved = host.routingContext[TestRoute.self].map { $0 as AnyObject }
        XCTAssertTrue(resolved === embedded,
                      "WrappedRouter should publish its router up to the hosting RoutingController's context")
    }

    /// `WrappedRouter` builds its router exactly once and hosts it without crashing
    /// (regression for mutating `@State` during a view update).
    func testWrappedRouterBuildsRouterOnce() {
        var createCount = 0
        let embedded = ViewCoordinator<TestRoute>(rootViewController: UIViewController())

        let host = UIHostingController(
            rootView: WrappedRouter { () -> ViewCoordinator<TestRoute> in
                createCount += 1
                return embedded
            }
        )
        window.rootViewController = host
        window.makeKeyAndVisible()

        asyncWait(for: 0.5)
        XCTAssertEqual(createCount, 1, "WrappedRouter should build the router exactly once")
    }
}
