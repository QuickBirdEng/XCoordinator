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
        master.view.backgroundColor = .yellow
        let c = NavigationCoordinator<TestRoute>(root: master)
        c.setRoot(for: window)
        return c
    }()

    func testNavigationPush(coordinator: NavigationCoordinator<TestRoute>) {
        print("will push", coordinator.rootViewController.viewControllers)
        let detail = UIViewController()
        viewControllers.append(detail)
        detail.view.backgroundColor = .red
        let exp = expectation(description: "push \(Date().timeIntervalSince1970)")
        let done = expectation(description: "push done \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(presentation: exp)
        DispatchQueue.main.async {
            coordinator.performTransition(.push(detail, animation: animation), with: .default) {
                done.fulfill()
            }
        }
        wait(for: [exp, done], timeout: 1, enforceOrder: true)
    }

    func testNavigationPop(coordinator: NavigationCoordinator<TestRoute>) {
        print(coordinator.rootViewController.viewControllers)
        let exp = expectation(description: "pop \(Date().timeIntervalSince1970)")
        let done = expectation(description: "pop done \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(dismissal: exp)
        DispatchQueue.main.async {
            coordinator.performTransition(.pop(animation: animation), with: .default) {
                done.fulfill()
            }
        }
        wait(for: [exp, done], timeout: 1, enforceOrder: true)
    }

    func testNavigationPopToRoot(coordinator: NavigationCoordinator<TestRoute>) {
        print(coordinator.rootViewController.viewControllers)
        let exp = expectation(description: "popToRoot \(Date().timeIntervalSince1970)")
        let done = expectation(description: "popToRoot done \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(dismissal: exp)
        DispatchQueue.main.async {
            coordinator.performTransition(.popToRoot(animation: animation), with: .default) {
                done.fulfill()
            }
        }
        wait(for: [exp, done], timeout: 1, enforceOrder: true)
    }

    func testNavigationSet(coordinator: NavigationCoordinator<TestRoute>) {
        let vcs = [UIColor.black, .blue, .green].map { color -> UIViewController in
            let vc = UIViewController()
            vc.view.backgroundColor = color
            return vc
        }
        print(coordinator.rootViewController.viewControllers)
        viewControllers.append(contentsOf: vcs)
        let exp = expectation(description: "set \(Date().timeIntervalSince1970)")
        let done = expectation(description: "set done \(Date().timeIntervalSince1970)")
        let animation = TestAnimation(presentation: exp)
        DispatchQueue.main.async {
            coordinator.performTransition(.set(vcs, animation: animation), with: .default) {
                done.fulfill()
            }
        }
        wait(for: [exp, done], timeout: 1, enforceOrder: true)
    }

    func testNavigationAnimations() {
        let exp = self.expectation(description: "done")

        testNavigationPush(coordinator: navigationCoordinator)
        sleep(2)
        testNavigationPop(coordinator: navigationCoordinator)
        sleep(2)
        testNavigationPush(coordinator: navigationCoordinator)
        sleep(2)
        testNavigationPopToRoot(coordinator: navigationCoordinator)
        sleep(2)
        testNavigationSet(coordinator: navigationCoordinator)
        exp.fulfill()

        wait(for: [exp], timeout: 10)
    }
}
