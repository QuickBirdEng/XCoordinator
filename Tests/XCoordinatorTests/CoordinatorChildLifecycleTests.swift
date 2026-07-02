//
//  CoordinatorChildLifecycleTests.swift
//  XCoordinatorTests
//
//  Created by Paul Kraft.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator
import XCTest

///
/// Regression coverage for the "deallocation-fix" (`Add children at the end of transitions after clearing
/// other children`).
///
/// `performTransition` used to register children *before* running the transition and call
/// `removeChildrenIfNeeded()` afterwards. Because a child coordinator's `rootViewController` is not yet in the
/// view hierarchy when a transition is kicked off — and `addChild` also wires the child's
/// `childTransitionCompleted()` back to the parent's `removeChildrenIfNeeded()` — any sweep firing during the
/// in-flight transition would judge the freshly-presented child "removable" and drop it from `children`,
/// deallocating the coordinator mid-presentation.
///
/// The fix moved `addChild` into the completion, *after* `removeChildrenIfNeeded()`
/// (`Coordinators/Coordinator.swift`): a newly-presented child is therefore added *after* the transition's own
/// removal sweep and survives it, while a later sweep still reclaims a child once its view controller is gone.
///
/// These tests drive `performTransition` with synchronous transitions so they validate that ordering
/// deterministically, without depending on on-screen presentation animations completing.
///
@MainActor
final class CoordinatorChildLifecycleTests: XCTestCase {

    // MARK: Tests

    /// Core regression: a child added by a transition must survive that transition's own
    /// `removeChildrenIfNeeded()` sweep, even before its view controller is in the hierarchy.
    ///
    /// Under the pre-fix ordering (`addChild` before `perform`, sweep in the completion) this child would be
    /// swept away and deallocated; under the fix it is added *after* the sweep and survives.
    func testPresentedChildSurvivesTransitionCompletionSweep() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: .init())

        weak var weakChild: BasicViewCoordinator<TestRoute>?
        let detachedViewController = UIViewController() // intentionally not in any view hierarchy

        autoreleasepool {
            let child = makeChildCoordinator(rootViewController: detachedViewController)
            weakChild = child
            parent.performTransition(.synchronouslyPresent(child), with: .default)
        }

        XCTAssertNotNil(weakChild, "Child added by the transition was swept/deallocated by the completion sweep")
        XCTAssertTrue(parent.children.contains { $0.viewController === detachedViewController },
                      "Child added by the transition was not tracked as a child")
    }

    /// No-leak guard: once a child's view controller is gone, a subsequent sweep must reclaim it — i.e. the
    /// fix did not trade the premature-deallocation bug for a retain leak.
    func testChildReleasedOnceRemovedFromHierarchy() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: .init())

        weak var weakChild: BasicViewCoordinator<TestRoute>?

        autoreleasepool {
            let child = makeChildCoordinator(rootViewController: UIViewController())
            weakChild = child
            parent.performTransition(.synchronouslyPresent(child), with: .default)
        }
        XCTAssertNotNil(weakChild, "Precondition: child should be retained after being added")

        // The child's view controller was never in the hierarchy, so the next sweep should reclaim it.
        parent.removeChildrenIfNeeded()

        XCTAssertNil(weakChild, "Child leaked — removeChildrenIfNeeded did not reclaim a vanished child")
        XCTAssertFalse(parent.children.contains { $0 is BasicViewCoordinator<TestRoute> },
                       "Reclaimed child is still tracked")
    }

    /// A child whose view controller is in the hierarchy must be kept by a sweep, and only released once it
    /// leaves the hierarchy. Exercises `canBeRemovedAsChild`'s hierarchy check end to end.
    func testChildInHierarchyIsKeptUntilItLeaves() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: .init())

        weak var weakChild: BasicViewCoordinator<TestRoute>?
        let childViewController = UIViewController()

        // Embed the child's view controller so `childViewController.parent != nil` (i.e. it is in the hierarchy).
        parent.rootViewController.addChild(childViewController)
        parent.rootViewController.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: parent.rootViewController)

        autoreleasepool {
            let child = makeChildCoordinator(rootViewController: childViewController)
            weakChild = child
            parent.performTransition(.synchronouslyPresent(child), with: .default)
        }

        // A sweep must NOT remove the child while its view controller is in the hierarchy.
        parent.removeChildrenIfNeeded()
        XCTAssertNotNil(weakChild, "Child in the view hierarchy was incorrectly reclaimed")
        XCTAssertTrue(parent.children.contains { $0.viewController === childViewController },
                      "Child in the view hierarchy was dropped from its parent")

        // Once it leaves the hierarchy, the next sweep reclaims it.
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
        parent.removeChildrenIfNeeded()

        XCTAssertNil(weakChild, "Child leaked after leaving the view hierarchy")
    }

    // MARK: Helpers

    private func makeChildCoordinator(rootViewController: UIViewController) -> BasicViewCoordinator<TestRoute> {
        BasicViewCoordinator<TestRoute>(rootViewController: rootViewController) { _ in .none() }
    }

}

extension Transition {

    /// A transition that "presents" a presentable but completes synchronously without any UIKit presentation,
    /// so child bookkeeping in `performTransition` can be exercised without on-screen rendering.
    static func synchronouslyPresent(_ presentable: any Presentable) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { _, _, completion in
            completion?()
        }
    }

}
