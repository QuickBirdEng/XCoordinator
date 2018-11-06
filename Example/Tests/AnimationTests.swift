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

    let window = UIWindow()

    func testAnimationCalled() {
        let tabs = [UIViewController(), UIViewController(), UIViewController(), UIViewController()]
        let coordinator = PageCoordinator<TestRoute>(pages: tabs)
        coordinator.setRoot(for: window)
        performTransition(on: coordinator, transition: { .set(tabs[0], tabs[2], direction: .forward, animation: $0) })
        // performTransition(on: coordinator, transition: { PageTransition. })
//        performTransition(on: coordinator, transition: { .select(tabs[1], animation: $0) })
//        performTransition(on: coordinator, transition: { .set(tabs, animation: $0) })
    }

    func performTransition<C: Coordinator>(on coordinator: C, transition: (Animation) -> C.TransitionType) {
        let expectation = XCTestExpectation(description: Date().timeIntervalSince1970.description)
        let testAnimation = TestAnimation(presentation: expectation, dismissal: expectation)
        let t = transition(testAnimation)
        print(t)
        coordinator.performTransition(t, with: TransitionOptions(animated: true))
        wait(for: [expectation], timeout: 0.5)
    }

    func testAnimationCalled<V: UIViewController>(for type: V.Type, including transitions: [Transition<V>], shouldCall: Bool) {
        let coordinator = BasicCoordinator<TestRoute, Transition<V>> { _ in .none() }
        for transition in transitions {
            coordinator.performTransition(transition, with: TransitionOptions(animated: shouldCall))
        }
    }
}
