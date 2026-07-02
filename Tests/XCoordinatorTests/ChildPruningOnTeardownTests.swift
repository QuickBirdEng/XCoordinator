//
//  ChildPruningOnTeardownTests.swift
//  XCoordinatorTests
//
//  Verifies that a child coordinator is pruned from its parent's `children` immediately once its
//  view controller leaves the view hierarchy — for ANY teardown path, including ones that bypass
//  XCoordinator entirely (a plain UIKit `dismiss()`/`removeFromParent()`, an interactive swipe, or
//  SwiftUI removing a hosted coordinator).
//
//  Prior to the lifecycle-observer fix, `removeChildrenIfNeeded()` only ran at a transition's
//  completion / `removeChild(_:)` / `childTransitionCompleted()` propagation, so a child torn down
//  outside those paths lingered until the next ancestor transition.
//
//  Note: the existing `CoordinatorChildLifecycleTests` remain valid and unchanged — those drive
//  never-view-loaded controllers, so no lifecycle observer attaches and behaviour is identical.
//

import SwiftUI
import UIKit
import XCoordinator
import XCTest

@MainActor
final class ChildPruningOnTeardownTests: XCTestCase {

    lazy var window = makeWindow()

    private func makeLeafCoordinator() -> BasicViewCoordinator<TestRoute> {
        BasicViewCoordinator<TestRoute>(rootViewController: UIViewController()) { _ in .none() }
    }

    // MARK: (a) RED characterization test

    /// Present a child through a normal transition, then tear it down with a plain UIKit `dismiss`
    /// that bypasses XCoordinator entirely. The child must leave `parent.children`.
    ///
    /// This failed before the fix (no trigger sweeps the parent) and passes after it (the child's
    /// lifecycle observer fires on window-leave and schedules the sweep).
    func testChildPrunedWhenDismissedBypassingXCoordinator() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        parent.setRoot(for: window)

        let child = makeLeafCoordinator()
        parent.performTransition(.present(child), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)

        XCTAssertTrue(parent.children.contains { $0.viewController === child.viewController },
                      "Precondition: presented child should be tracked")

        // Bypass XCoordinator: dismiss the presented controller directly.
        child.viewController.dismiss(animated: false)
        asyncWait(for: 0.5)

        XCTAssertFalse(parent.children.contains { $0.viewController === child.viewController },
                       "Child dismissed outside XCoordinator was not pruned from children")
    }

    // MARK: (b) Modal dismiss prunes and deallocates

    /// A modally presented child, once dismissed, is both pruned from `children` and deallocated —
    /// proving the prune is not merely a tracking update masking a leak.
    func testModalDismissPrunesAndDeallocatesChild() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        parent.setRoot(for: window)

        weak var weakChild: BasicViewCoordinator<TestRoute>?
        autoreleasepool {
            let child = makeLeafCoordinator()
            weakChild = child
            parent.performTransition(.present(child), with: TransitionOptions(animated: false))
        }
        asyncWait(for: 0.5)
        XCTAssertNotNil(weakChild, "Precondition: child retained via parent.children")

        parent.viewController.dismiss(animated: false)
        asyncWait(for: 0.5)

        XCTAssertFalse(parent.children.contains { $0 is BasicViewCoordinator<TestRoute> },
                       "Child not pruned after modal dismiss")
        XCTAssertNil(weakChild, "Child not deallocated after modal dismiss + prune")
    }

    // MARK: (c) Interactive swipe-dismiss (animated proxy)

    /// Proxy for an interactive swipe-to-dismiss. UIKit gesture state isn't deterministically
    /// drivable in a unit test, and the observer keys purely on window-leave — it neither can nor
    /// needs to distinguish an interactive dismissal from a programmatic animated one. So an animated
    /// `dismiss` exercises the identical teardown path.
    func testAnimatedDismissPrunesChild() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        parent.setRoot(for: window)

        let child = makeLeafCoordinator()
        parent.performTransition(.present(child), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)
        XCTAssertTrue(parent.children.contains { $0.viewController === child.viewController })

        parent.viewController.dismiss(animated: true)
        asyncWait(for: 1.0)

        XCTAssertFalse(parent.children.contains { $0.viewController === child.viewController },
                       "Child not pruned after animated (interactive-proxy) dismiss")
    }

    // MARK: (d) SwiftUI-hosted teardown

    /// A SwiftUI-hosted coordinator (its root is a `RoutingController`) put into the hierarchy through
    /// an `addChild`'d path must be pruned and deallocated on teardown. Guards against a vacuous pass:
    /// asserts it was actually tracked (observer attached). `WrappedRouter`-created coordinators are
    /// out of scope — they are never `addChild`'d and self-free via SwiftUI's `@StateObject`.
    func testSwiftUIHostedChildPrunedOnTeardown() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        parent.setRoot(for: window)

        weak var weakChild: ViewCoordinator<TestRoute>?
        autoreleasepool {
            let child = ViewCoordinator<TestRoute>(body: { Color.clear })
            weakChild = child
            parent.performTransition(.present(child), with: TransitionOptions(animated: false))
        }
        asyncWait(for: 0.5)
        XCTAssertTrue(parent.children.contains { $0 is ViewCoordinator<TestRoute> },
                      "Precondition: SwiftUI-hosted coordinator must be addChild'd so an observer attaches")
        XCTAssertNotNil(weakChild)

        parent.viewController.dismiss(animated: false)
        asyncWait(for: 0.5)

        XCTAssertFalse(parent.children.contains { $0 is ViewCoordinator<TestRoute> },
                       "SwiftUI-hosted child not pruned on teardown")
        XCTAssertNil(weakChild, "SwiftUI-hosted child not deallocated after prune")
    }

    // MARK: (e) Push then pop — unchanged behaviour (regression guard)

    /// The observer must not disturb the ordinary push/pop lifecycle: a pushed child is tracked, and
    /// after a normal `pop` it ends up pruned — the same final `children` state as before the fix.
    func testPushThenPopLeavesConsistentChildren() {
        let nav = BasicNavigationCoordinator<TestRoute>(
            rootViewController: UINavigationController(rootViewController: UIViewController())
        ) { _ in .none() }
        nav.setRoot(for: window)

        let child = makeLeafCoordinator()
        nav.performTransition(.push(child), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)
        XCTAssertTrue(nav.children.contains { $0.viewController === child.viewController },
                      "Pushed child should be tracked")

        nav.performTransition(.pop(), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)
        XCTAssertFalse(nav.children.contains { $0.viewController === child.viewController },
                       "Popped child should be pruned")
    }

    // MARK: (f) NO-OP guard — covered / deselected children survive

    /// A child merely *covered* by a fullscreen present still has a `presentedViewController`, so
    /// `isInViewHierarchy` keeps it — it must NOT be pruned even though its view left the window and
    /// its observer fired. This proves the mechanism cannot over-prune a still-live child.
    func testCoveredChildIsNotPruned() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        parent.setRoot(for: window)

        let a = makeLeafCoordinator()
        parent.performTransition(.present(a), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)
        XCTAssertTrue(parent.children.contains { $0.viewController === a.viewController })

        // A presents B fullscreen; A's view leaves the window (covered) → A's observer fires.
        let b = makeLeafCoordinator()
        b.viewController.modalPresentationStyle = .fullScreen
        a.performTransition(.present(b), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)

        XCTAssertTrue(parent.children.contains { $0.viewController === a.viewController },
                      "Covered child A must NOT be pruned (still has a presentedViewController)")
    }

    /// A deselected tab's child keeps `tabBarController != nil`, so switching tabs (its view leaves
    /// the window, observer fires) must not prune it.
    func testDeselectedTabChildIsNotPruned() {
        let first = makeLeafCoordinator()
        let second = makeLeafCoordinator()
        let tab = TabBarCoordinator<TestRoute>(tabs: [first, second], select: first)
        tab.setRoot(for: window)
        asyncWait(for: 0.5)

        tab.performTransition(.select(second), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)

        XCTAssertTrue(tab.children.contains { $0.viewController === first.viewController },
                      "Deselected tab child must NOT be pruned (still has a tabBarController)")
    }

    // MARK: (g) Reuse safety — off-screen page controllers survive and are reused

    /// A `UIPageViewController` page swiped off-screen and back must still be reusable: the page data
    /// source retains the page controllers independently of `children`, so the eager observer does not
    /// prune a reused controller into oblivion. Verifies the same instance is re-shown.
    func testPageReuseSurvivesSwipeOffAndBack() {
        let vc0 = UIViewController()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let page = PageCoordinator<TestRoute>(pages: [vc0, vc1, vc2], set: vc0)
        page.setRoot(for: window)
        asyncWait(for: 0.5)

        // Proxy for paging: move to vc2 (vc0 goes off-screen), then back to vc0.
        page.performTransition(.set(vc2, direction: .forward), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)
        page.performTransition(.set(vc0, direction: .reverse), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)

        XCTAssertTrue(page.rootViewController.viewControllers?.first === vc0,
                      "PageCoordinator must re-show the same off-screen-then-returned controller (reuse intact)")
    }

    /// The router/coordinator — not just the view controller — must survive an off-screen period. A page
    /// *coordinator* is held only by `children`; when its view controller goes off-screen (the data source
    /// still retains the VC and reuses it), pruning would deallocate the coordinator, leaving a live-but-
    /// unrouted page. `PageCoordinator` must retain its page presentables for its own lifetime so the
    /// coordinator survives and remains functional after reuse.
    func testPageCoordinatorPageCoordinatorKeptAndFunctionalAcrossSwipe() {
        // Page view controllers are retained by the data source; hold them to drive paging.
        let vc0 = UIViewController()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        var didRoute = false
        weak var weakPage0: BasicViewCoordinator<TestRoute>?
        var page: PageCoordinator<TestRoute>!

        autoreleasepool {
            let p0 = BasicViewCoordinator<TestRoute>(rootViewController: vc0) { _ in
                didRoute = true
                return .none()
            }
            let p1 = BasicViewCoordinator<TestRoute>(rootViewController: vc1) { _ in .none() }
            let p2 = BasicViewCoordinator<TestRoute>(rootViewController: vc2) { _ in .none() }
            weakPage0 = p0
            page = PageCoordinator<TestRoute>(pages: [p0, p1, p2], set: p0)
        }
        page.setRoot(for: window)
        asyncWait(for: 0.5)
        XCTAssertNotNil(weakPage0, "Precondition: page 0 coordinator alive while shown")

        // Swipe off page 0 to page 2, then back — the coordinator is off-screen in between.
        page.performTransition(.set(vc2, direction: .forward), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)
        page.performTransition(.set(vc0, direction: .reverse), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)

        XCTAssertNotNil(weakPage0, "Off-screen page coordinator must be kept for reuse, not deallocated")
        // ...and still functional: routing on the reused coordinator still runs its transitions.
        weakPage0?.trigger(.home)
        XCTAssertTrue(didRoute, "Reused page coordinator must still route")
    }

    // MARK: (h) Container-child — subview injection must not disturb container VCs

    /// The observer is added as a subview of the child's root view — which for a `NavigationCoordinator`
    /// is a `UINavigationController`'s view. Assert (i) the container is intact and still functional with
    /// the hidden observer attached, and (ii) it is pruned + deallocated on teardown.
    func testNavigationContainerChildIsIntactThenPruned() {
        let parent = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
        parent.setRoot(for: window)

        var navChild: BasicNavigationCoordinator<TestRoute>? = BasicNavigationCoordinator<TestRoute>(
            rootViewController: UINavigationController(rootViewController: UIViewController())
        ) { _ in .none() }
        weak var weakChild = navChild
        let navVC = navChild?.viewController as? UINavigationController

        parent.performTransition(.present(navChild!), with: TransitionOptions(animated: false))
        asyncWait(for: 0.5)

        // (i) Container integrity: the hidden observer subview must not disturb the nav stack.
        XCTAssertEqual(navVC?.viewControllers.count, 1, "nav stack intact with observer attached")
        navChild?.performTransition(.push(UIViewController()), with: TransitionOptions(animated: false))
        asyncWait(for: 0.3)
        XCTAssertEqual(navVC?.viewControllers.count, 2, "nav container still functional with observer attached")

        // (ii) Prune + dealloc on teardown.
        navChild = nil
        parent.viewController.dismiss(animated: false)
        asyncWait(for: 0.5)
        XCTAssertFalse(parent.children.contains { $0 is BasicNavigationCoordinator<TestRoute> },
                       "nav container child not pruned on teardown")
        XCTAssertNil(weakChild, "nav container child not deallocated after prune")
    }

    // MARK: Scope validation — WrappedRouter-hosted coordinators self-free (the originating symptom)

    /// The task originated from "the SwiftUI home coordinator deallocated only on the next login, not on
    /// logout." `WrappedRouter`-created coordinators are deliberately *out of scope* for the lifecycle
    /// observer (they are never `addChild`'d), on the premise that SwiftUI already frees them when their
    /// hosting view identity tears down. This test verifies that premise rather than asserting it: a
    /// coordinator created by a `WrappedRouter` must deallocate once its host is removed from the window.
    func testWrappedRouterHostedCoordinatorDeallocatesOnTeardown() {
        weak var weakEmbedded: ViewCoordinator<TestRoute>?

        autoreleasepool {
            let host = RoutingController {
                WrappedRouter { () -> ViewCoordinator<TestRoute> in
                    let created = ViewCoordinator<TestRoute>(rootViewController: UIViewController())
                    weakEmbedded = created
                    return created
                }
            }
            window.rootViewController = host
            window.makeKeyAndVisible()
            asyncWait(for: 0.5)
            XCTAssertNotNil(weakEmbedded, "Precondition: WrappedRouter created and retained the coordinator")

            // Tear the host down: replace the window root and release the host.
            window.rootViewController = UIViewController()
        }
        asyncWait(for: 0.5)

        XCTAssertNil(weakEmbedded,
                     "WrappedRouter-hosted coordinator should self-free on teardown (validates the scope boundary)")
    }
}
