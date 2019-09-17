//
//  TransitionTests.swift
//  XCoordinatorTests
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator
import XCTest

class TransitionTests: XCTestCase {

    // MARK: Static properties

    static let allTests = [
        ("testPageCoordinator", testPageCoordinator),
        ("testSplitCoordinator", testSplitCoordinator),
        ("testTabBarCoordinator", testTabBarCoordinator),
        ("testViewCoordinator", testViewCoordinator),
        ("testNavigationCoordinator", testNavigationCoordinator),
    ]

    // MARK: Stored properties

    lazy var window = UIWindow()

    // MARK: Tests

    func testPageCoordinator() {
        let pages = [UIViewController(), UIViewController(), UIViewController()]
        let coordinator = PageCoordinator<TestRoute>(pages: pages)
        coordinator.setRoot(for: window)
        testStandardTransitions(on: coordinator)
        testCompletionCalled(on: coordinator, transition: .set(pages[0], direction: .forward))
        coordinator.rootViewController.isDoubleSided = true
        testCompletionCalled(on: coordinator, transition: .set(pages[1], pages[2], direction: .forward))
    }

    func testSplitCoordinator() {
        let coordinator = SplitCoordinator<TestRoute>(master: UIViewController(), detail: UIViewController())
        coordinator.setRoot(for: window)
        testStandardTransitions(on: coordinator)
        testCompletionCalled(
            on: coordinator,
            transition: .multiple(.show(UIViewController()), .showDetail(UIViewController()))
        )
    }

    func testTabBarCoordinator() {
        let tabs0 = [UIViewController(), UIViewController()]
        let coordinator = TabBarCoordinator<TestRoute>(tabs: tabs0)
        coordinator.setRoot(for: window)
        testStandardTransitions(on: coordinator)
        let tabs1 = [UIViewController(), UIViewController()]
        testCompletionCalled(on: coordinator, transition: .multiple(.set(tabs1), .select(tabs1[1])))
        testCompletionCalled(on: coordinator, transition: .multiple(.set(tabs0), .select(index: 1)))
    }

    func testViewCoordinator() {
        let coordinator = ViewCoordinator<TestRoute>(rootViewController: .init())
        coordinator.setRoot(for: window)
        testStandardTransitions(on: coordinator)
    }

    func testNavigationCoordinator() {
        let coordinator = NavigationCoordinator<TestRoute>(root: UIViewController())
        coordinator.setRoot(for: window)
        testStandardTransitions(on: coordinator)
        testCompletionCalled(on: coordinator, transition: .push(UIViewController()))
        testCompletionCalled(on: coordinator, transition: .pop())
        testCompletionCalled(on: coordinator, transition: .push(UIViewController()))
        testCompletionCalled(on: coordinator, transition: .popToRoot())

        let viewControllers = [UIViewController(), UIViewController()]
        testCompletionCalled(on: coordinator, transition: .set(viewControllers))
        testCompletionCalled(on: coordinator, transition: .pop(to: viewControllers[0]))
    }

    // MARK: Helpers

    private func testStandardTransitions<C: Coordinator, RootViewController>(on coordinator: C) where C.TransitionType == Transition<RootViewController> {
        print("none")
        testCompletionCalled(on: coordinator, transition: .none())
        print("present")
        testCompletionCalled(on: coordinator, transition: .present(UIViewController()))
        print("dismiss")
        testCompletionCalled(on: coordinator, transition: .dismiss())
        print("embed")
        testCompletionCalled(on: coordinator, transition: .embed(UIViewController(), in: UIViewController()))
        print("multiple(none)")
        testCompletionCalled(on: coordinator, transition: .multiple(.none()))
        print("multiple(empty)")
        testCompletionCalled(on: coordinator, transition: .multiple())
    }

    private func testCompletionCalled<C: Coordinator>(on coordinator: C, transition: C.TransitionType) {
        let exp = expectation(description: "\(Date().timeIntervalSince1970)")
        DispatchQueue.main.async {
            coordinator.performTransition(transition, with: .init(animated: true)) {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 3)
    }

}
