//
//  ContextMenuInteractionTests.swift
//  XCoordinatorTests
//
//  Created by Paul Kraft.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

#if os(iOS)

import UIKit
@testable import XCoordinator
import XCTest

///
/// Guards that the context-menu interaction performs its route through `performTransition` — so a coordinator
/// presented from a context menu is retained as a child rather than deallocated.
///
/// The legacy implementation ran `transition.perform(...)` directly, bypassing child management. This is the
/// same hazard the deallocation-fix addresses (see `CoordinatorChildLifecycleTests`).
///
@MainActor
final class ContextMenuInteractionTests: XCTestCase {

    // MARK: Stored properties

    lazy var window = makeWindow()

    // MARK: Tests

    func testCommittingPreviewRetainsPresentedCoordinatorAsChild() {
        let coordinator = ContextMenuTestCoordinator()
        coordinator.setRoot(for: window)

        let delegate = coordinator.contextMenuInteractionDelegate(for: .home)
        guard let concreteDelegate = delegate as? CoordinatorContextMenuInteractionDelegate<ContextMenuTestCoordinator> else {
            return XCTFail("Unexpected delegate type: \(type(of: delegate))")
        }

        XCTAssertTrue(coordinator.children.isEmpty, "Precondition: no children before committing the preview")

        concreteDelegate.performRoute()

        XCTAssertTrue(
            coordinator.children.contains { $0.viewController === coordinator.child.viewController },
            "Coordinator presented from the context menu was not retained as a child"
        )
    }

}

@MainActor
private final class ContextMenuTestCoordinator: ViewCoordinator<TestRoute> {

    let child = BasicViewCoordinator<TestRoute>(rootViewController: .init()) { _ in .present(UIViewController()) }

    init() {
        super.init(rootViewController: .init())
    }

    // A synchronous transition so the test does not depend on on-screen presentation animations completing.
    override func prepareTransition(for route: TestRoute) -> ViewTransition {
        .synchronouslyPresent(child)
    }

}

#endif
