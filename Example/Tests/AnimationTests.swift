//
//  AnimationTests.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

@testable import XCoordinator
import XCTest

class AnimationTests: XCTestCase {

    // MARK: - Stored properties

    let window = UIWindow()

    // MARK: - Tests

    func testViewCoordinator() {
        let coordinator = ViewCoordinator<TestRoute>(root: UIViewController())
        coordinator.setRoot(for: window)
        testStandardAnimationsCalled(on: coordinator)
    }

    func testSplitCoordinator() {
        let coordinator = SplitCoordinator<TestRoute>(master: UIViewController(), detail: UIViewController())
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

        testStaticAnimationCalled(on: coordinator, transition: { .select(tabs[1], animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .select(tabs[2], animation: $0) })

        testStaticAnimationCalled(on: coordinator, transition: { .select(index: 1, animation: $0) })
        testInteractiveAnimationCalled(on: coordinator, transition: { .select(index: 2, animation: $0) })

        testStaticAnimationCalled(
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

    // MARK: - Helpers

    private func testStandardAnimationsCalled<C: Coordinator, RootViewController>(on coordinator: C) where C.TransitionType == Transition<RootViewController> {
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
                                                           transition: (Animation) -> C.TransitionType) {
        let animationExpectation = expectation(description: "Animation \(Date().timeIntervalSince1970)")
        let completionExpectation = expectation(description: "Completion \(Date().timeIntervalSince1970)")
        print(#function, animationExpectation)
        let testAnimation = TestAnimation.static(presentation: animationExpectation, dismissal: animationExpectation)
        let t = transition(testAnimation)
        coordinator.performTransition(t, with: TransitionOptions(animated: true)) {
            completionExpectation.fulfill()
        }
        wait(for: [animationExpectation, completionExpectation], timeout: 3, enforceOrder: true)
        asyncWait(for: 0.1)
    }

    private func testInteractiveAnimationCalled<C: Coordinator>(on coordinator: C,
                                                                transition: (Animation) -> C.TransitionType) {
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
        }
        wait(for: [animationExpectation, completionExpectation], timeout: 3, enforceOrder: true)
        asyncWait(for: 0.1)
    }
}

extension Animation {
    static let `default` = Animation(presentation: nil, dismissal: nil)
}
