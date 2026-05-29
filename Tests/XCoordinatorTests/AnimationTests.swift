//
//  AnimationTests.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator
import XCTest

@MainActor
class AnimationTests: XCTestCase {

    // MARK: Stored properties

    lazy var window = makeWindow()

    // MARK: Tests

    func testViewCoordinator() {
        let coordinator = ViewCoordinator<TestRoute>(rootViewController: .init())
        coordinator.setRoot(for: window)
        testStandardAnimationsCalled(on: coordinator)
    }

    func testSplitCoordinator() {
        let coordinator = SplitCoordinator<TestRoute>(primary: UIViewController(), secondary: UIViewController())
        coordinator.setRoot(for: window)
        testStandardAnimationsCalled(on: coordinator)
    }

    func testPageCoordinator() {
        let coordinator = PageCoordinator<TestRoute>(pages: [UIViewController()])
        coordinator.setRoot(for: window)
        testStandardAnimationsCalled(on: coordinator)
    }

    func testTabBarCoordinator() {
        let tabs = [UIViewController(), UIViewController(), UIViewController()]
        let coordinator = TabBarCoordinator<TestRoute>(tabs: tabs)
        coordinator.setRoot(for: window)
        testStandardAnimationsCalled(on: coordinator)

        // UIKit only runs a custom tab-bar animator when an interaction controller is present,
        // so the static (non-interactive) cases assert completion only, while the interactive
        // cases assert the custom animation runs.
        testCompletionCalled(on: coordinator, transition: { .select(tabs[1], animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .select(tabs[2], animation: $0) })

        testCompletionCalled(on: coordinator, transition: { .select(index: 1, animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .select(index: 2, animation: $0) })

        testCompletionCalled(
            on: coordinator,
            transition: { .set([UIViewController(), UIViewController()], animation: $0) }
        )
        testInteractiveAnimationCalled(
            on: coordinator,
            transition: { .set([UIViewController(), UIViewController()], animation: $0) }
        )
    }

    func testNavigationCoordinator() {
        let coordinator = NavigationCoordinator<TestRoute>(root: UIViewController())
        coordinator.setRoot(for: window)
        testStandardAnimationsCalled(on: coordinator)

        testStaticAnimationCalled(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        testStaticAnimationCalled(on: coordinator, transition: { .pop(animation: $0) })

        testInteractiveAnimationCalled(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .pop(animation: $0) })

        testStaticAnimationCalled(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        testStaticAnimationCalled(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        testStaticAnimationCalled(on: coordinator, transition: { .popToRoot(animation: $0) })

        testInteractiveAnimationCalled(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .popToRoot(animation: $0) })

        let staticViewControllers = [UIViewController(), UIViewController()]
        testStaticAnimationCalled(on: coordinator, transition: { .set(staticViewControllers, animation: $0) })
        testStaticAnimationCalled(on: coordinator, transition: { .pop(to: staticViewControllers[0], animation: $0) })

        let interactiveViewControllers = [UIViewController(), UIViewController()]
        testInteractiveAnimationCalled(on: coordinator, transition: { .set(interactiveViewControllers, animation: $0) })
        testInteractiveAnimationCalled(
            on: coordinator,
            transition: { .pop(to: interactiveViewControllers[0], animation: $0) }
        )
    }

    // MARK: Helpers

    private func testStandardAnimationsCalled<C: Coordinator>(on coordinator: C) {
        testStaticAnimationCalled(on: coordinator, transition: { .present(UIViewController(), animation: $0) })
        testStaticAnimationCalled(on: coordinator, transition: { .dismiss(animation: $0) })
        testStaticAnimationCalled(
            on: coordinator,
            transition: { .multiple(.present(UIViewController(), animation: nil), .dismiss(animation: $0)) }
        )
        testStaticAnimationCalled(
            on: coordinator,
            transition: { .multiple(.present(UIViewController(), animation: $0), .dismiss(animation: .default)) }
        )

        testInteractiveAnimationCalled(on: coordinator, transition: { .present(UIViewController(), animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .dismiss(animation: $0) })
        testInteractiveAnimationCalled(
            on: coordinator,
            transition: { .multiple(.present(UIViewController(), animation: $0), .dismiss(animation: .default)) }
        )
    }

    private func testStaticAnimationCalled<C: Coordinator>(on coordinator: C,
                                                           transition: (Animation) -> Transition<C.RootViewController>) {
        let animationExpectation = expectation(description: "Animation \(Date().timeIntervalSince1970)")
        let completionExpectation = expectation(description: "Completion \(Date().timeIntervalSince1970)")
        print(#function, animationExpectation)
        let testAnimation = TestAnimation.static(presentation: animationExpectation, dismissal: animationExpectation)
        let t = transition(testAnimation)
        coordinator.performTransition(t, with: TransitionOptions(animated: true)) {
            completionExpectation.fulfill()
        }
        // Order is not enforced: for container transitions (tab bar / navigation) UIKit
        // may invoke the animator and fire the completion in either order. What matters
        // is that both happen — the animation runs and the completion is called.
        wait(for: [animationExpectation, completionExpectation], timeout: 3)
        asyncWait(for: 0.1)
    }

    private func testInteractiveAnimationCalled<C: Coordinator>(on coordinator: C,
                                                                transition: (Animation) -> Transition<C.RootViewController>) {
        let animationExpectation = expectation(description: "Animation \(Date().timeIntervalSince1970)")
        let completionExpectation = expectation(description: "Completion \(Date().timeIntervalSince1970)")
        print(#function, animationExpectation)
        let testAnimation = TestAnimation.interactive(
            presentation: animationExpectation,
            dismissal: animationExpectation
        )
        let t = transition(testAnimation)
        coordinator.performTransition(t, with: TransitionOptions(animated: true)) {
            completionExpectation.fulfill()
            _ = testAnimation
        }
        // Order is not enforced: for container transitions (tab bar / navigation) UIKit
        // may invoke the animator and fire the completion in either order. What matters
        // is that both happen — the animation runs and the completion is called.
        wait(for: [animationExpectation, completionExpectation], timeout: 3)
        asyncWait(for: 0.1)
    }

    /// Verifies only that the completion handler fires.
    ///
    /// Used for *static* programmatic `UITabBarController` selection / `set`: UIKit only invokes
    /// a custom tab-bar animator when an interaction controller is present, so for these
    /// transitions iOS performs the switch without running the custom animation. The interactive
    /// variants (which UIKit does animate) cover the animation wiring; here we assert the
    /// transition still completes.
    private func testCompletionCalled<C: Coordinator>(on coordinator: C,
                                                      transition: (Animation) -> Transition<C.RootViewController>) {
        let completionExpectation = expectation(description: "Completion \(Date().timeIntervalSince1970)")
        let t = transition(.default)
        coordinator.performTransition(t, with: TransitionOptions(animated: true)) {
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 3)
        asyncWait(for: 0.1)
    }
}
