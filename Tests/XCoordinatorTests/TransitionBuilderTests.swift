//
//  TransitionBuilderTests.swift
//  XCoordinatorTests
//
//  Verifies the @TransitionBuilder result builder composes transitions as documented.
//

import UIKit
import XCoordinator
import XCTest

@MainActor
final class TransitionBuilderTests: XCTestCase {

    @TransitionBuilder<UIViewController>
    private func twoStatements(_ first: UIViewController, _ second: UIViewController) -> ViewTransition {
        Transition.present(first)
        Transition.present(second)
    }

    @TransitionBuilder<UIViewController>
    private func conditional(_ include: Bool, _ viewController: UIViewController) -> ViewTransition {
        if include {
            Transition.present(viewController)
        } else {
            Transition.none()
        }
    }

    @TransitionBuilder<UIViewController>
    private func single(_ viewController: UIViewController) -> ViewTransition {
        Transition.present(viewController)
    }

    /// Listing several statements chains them like `.multiple`, preserving order.
    func testBuilderChainsStatementsInOrder() {
        let first = UIViewController()
        let second = UIViewController()
        let transition = twoStatements(first, second)
        XCTAssertEqual(transition.presentables.count, 2)
        XCTAssertTrue(transition.presentables[0].viewController === first)
        XCTAssertTrue(transition.presentables[1].viewController === second)
    }

    /// `if`/`else` (buildEither) selects the right branch.
    func testBuilderConditionalBranches() {
        let viewController = UIViewController()
        XCTAssertEqual(conditional(true, viewController).presentables.count, 1)
        XCTAssertEqual(conditional(false, viewController).presentables.count, 0)
    }

    /// A single statement passes through unchanged.
    func testBuilderSingleStatementPassthrough() {
        let viewController = UIViewController()
        let transition = single(viewController)
        XCTAssertEqual(transition.presentables.count, 1)
        XCTAssertTrue(transition.presentables[0].viewController === viewController)
    }
}
