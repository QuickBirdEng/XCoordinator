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
    var viewControllers = [UIViewController]()
    lazy var window: UIWindow = UIApplication.shared.keyWindow ?? UIWindow()

    lazy var navigationCoordinator: NavigationCoordinator<TestRoute> = {
        let master = UIViewController()
        viewControllers.append(master)
        let c = NavigationCoordinator<TestRoute>(root: master)
        c.setRoot(for: window)
        return c
    }()

    func testNavigationPush(coordinator: NavigationCoordinator<TestRoute>) {
        print(coordinator.rootViewController.viewControllers)
        let detail = UIViewController()
        viewControllers.append(detail)
        detail.loadViewIfNeeded()
        let exp = expectation(description: "push \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(presentation: exp)
        coordinator.performTransition(.push(detail, animation: animation), with: .default)
        wait(for: [exp], timeout: 1)
    }

    func testNavigationPop(coordinator: NavigationCoordinator<TestRoute>) {
        print(coordinator.rootViewController.viewControllers)
        let exp = expectation(description: "pop \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(dismissal: exp)
        coordinator.performTransition(.pop(animation: animation), with: .default)
        wait(for: [exp], timeout: 1)
    }

    func testNavigationPopToRoot(coordinator: NavigationCoordinator<TestRoute>) {
        print(coordinator.rootViewController.viewControllers)
        let exp = expectation(description: "popToRoot \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(dismissal: exp)
        coordinator.performTransition(.popToRoot(animation: animation), with: .default)
        wait(for: [exp], timeout: 1)
    }

    func testNavigationSet(coordinator: NavigationCoordinator<TestRoute>) {
        let vcs = (0..<3).map { _ in UIViewController() }
        print(coordinator.rootViewController.viewControllers)
        viewControllers.append(contentsOf: vcs)
        let exp = expectation(description: "set \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(presentation: exp)
        coordinator.performTransition(.set(vcs, animation: animation), with: .default)
        wait(for: [exp], timeout: 1)
    }

    func testNavigationAnimations() {
        let exp = self.expectation(description: "done")

        navigationCoordinator.rootViewController.loadViewIfNeeded()
        testNavigationPush(coordinator: navigationCoordinator)
        testNavigationPop(coordinator: navigationCoordinator)
        testNavigationPush(coordinator: navigationCoordinator)
        testNavigationPopToRoot(coordinator: navigationCoordinator)
        testNavigationSet(coordinator: navigationCoordinator)
        exp.fulfill()

        wait(for: [exp], timeout: 10)
    }
}
