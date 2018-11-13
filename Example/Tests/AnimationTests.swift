//
//  AnimationTests.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest
@testable import XCoordinator

class AnimationTests: XCTestCase {
    // TODO: Add tests to ensure animations are called
    // e.g. on UISplitViewController, UIPageViewController once added

    let window = UIWindow()

    func testTabBarCoordinatorAnimations() {
        let tabs = [UIViewController(), UIViewController(), UIViewController()]
        let coordinator = TabBarCoordinator<TestRoute>(tabs: tabs)
        coordinator.setRoot(for: window)
        performTransition(on: coordinator, transition: { .select(tabs[1], animation: $0) })
        performTransition(on: coordinator, transition: { .select(index: 2, animation: $0) })
    }

    func testNavigationCoordinatorAnimations() {
        let coordinator = NavigationCoordinator<TestRoute>(root: UIViewController())
        coordinator.setRoot(for: window)
        performTransition(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        performTransition(on: coordinator, transition: { .pop(animation: $0) })
        performTransition(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        performTransition(on: coordinator, transition: { .push(UIViewController(), animation: $0) })
        performTransition(on: coordinator, transition: { .popToRoot(animation: $0) })

    }

    func performTransition<C: Coordinator>(on coordinator: C, transition: (Animation) -> C.TransitionType) {
        let expectation = XCTestExpectation(description: Date().timeIntervalSince1970.description)
        let testAnimation = TestAnimation(presentation: expectation, dismissal: expectation)
        let t = transition(testAnimation)
        coordinator.performTransition(t, with: TransitionOptions(animated: true))
        wait(for: [expectation], timeout: 0.5)
    }
}
