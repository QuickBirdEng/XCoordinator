//
//  TestRoute.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest
@testable import XCoordinator

class TransitionTests: XCTestCase {

    func testCompletionsCalled() {
        let presentable = UIViewController()
        testCompletionBlockCalled(for: UIViewController.self, including: [])
        testCompletionBlockCalled(for: UINavigationController.self, including: [
            .push(presentable),
            .pop(),
            .popToRoot()
        ])
        testCompletionBlockCalled(for: UIPageViewController.self, including: [
            .set(presentable, direction: .forward)
        ])
        testCompletionBlockCalled(for: UITabBarController.self, including: [
            .multiple(.set([presentable]), .select(presentable)),
            .multiple(.set([presentable]), .select(index: 0)),
        ])
    }

    func testCompletionBlockCalled<V: UIViewController>(for type: V.Type, including: [Transition<V>]) {
        let containerVC = UIViewController()
        containerVC.loadViewIfNeeded()
        let container = containerVC.view!
        let presentable = UIViewController()
        testCompletionCalled(transitionTypes: [
            .none(),
            // .present(presentable),
            .embed(presentable, in: container),
            .multiple(.none()),
            .multiple()
        ] + including)
    }

    func testCompletionCalled<V: UIViewController>(transitionTypes: [Transition<V>]) {
        for (index, transition) in transitionTypes.enumerated() { // registerPeek does not call completion unless triggered
            let coordinator = BasicCoordinator<TestRoute, Transition<V>> { _ in .none() }
            let exp = expectation(description: "\(transition)")
            coordinator.performTransition(transition, with: .default) {
                exp.fulfill()
            }
            waitForExpectations(timeout: 0.5) { err in
                guard let error = err else { return }
                print(error, transition, index)
            }
        }
    }
}
