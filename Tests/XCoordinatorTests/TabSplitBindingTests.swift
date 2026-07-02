//
//  TabSplitBindingTests.swift
//  XCoordinatorTests
//
//  Regression tests for the TabBarCoordinator binding initializers and SplitCoordinator columns.
//

import SwiftUI
import UIKit
import XCoordinator
import XCTest

@MainActor
final class TabSplitBindingTests: XCTestCase {

    lazy var window = makeWindow()

    /// An empty `items` collection must not crash the binding initializer.
    func testTabBarEmptyItemsDoesNotCrash() {
        var selection = -1
        let binding = Binding(get: { selection }, set: { selection = $0 })
        let coordinator = TabBarCoordinator<TestRoute>(items: [Int](), selection: binding) { _ in
            UIViewController()
        }
        coordinator.setRoot(for: window)
        asyncWait(for: 0.1)
        XCTAssertEqual(coordinator.rootViewController.viewControllers?.count ?? 0, 0)
    }

    /// A non-zero-based collection (e.g. an `ArraySlice`) must select the correct tab and not crash,
    /// because the tab bar's 0-based index space differs from the collection's index space.
    func testTabBarNonZeroBasedSliceSelectsCorrectTab() {
        let slice = [10, 20, 30][1...] // [20, 30], startIndex == 1
        var selection = 30
        let binding = Binding(get: { selection }, set: { selection = $0 })
        let coordinator = TabBarCoordinator<TestRoute>(items: slice, selection: binding) { value in
            let viewController = UIViewController()
            viewController.title = "\(value)"
            return viewController
        }
        coordinator.setRoot(for: window)
        asyncWait(for: 0.2)

        XCTAssertEqual(coordinator.rootViewController.viewControllers?.count, 2)
        XCTAssertEqual(selection, 30, "the caller's selection must not be clobbered to a wrong value")
        XCTAssertEqual(coordinator.rootViewController.selectedViewController?.title, "30")
    }

    /// The supplementary column must be populated on a triple-column split controller.
    func testSplitSupplementaryColumnIsPopulated() {
        let split = UISplitViewController(style: .tripleColumn)
        let primary = UIViewController()
        let secondary = UIViewController()
        let supplementary = UIViewController()
        let coordinator = SplitCoordinator<TestRoute>(
            rootViewController: split,
            primary: primary,
            secondary: secondary,
            supplementary: supplementary
        )
        coordinator.setRoot(for: window)
        asyncWait(for: 0.3)

        XCTAssertTrue(split.viewController(for: .primary) === primary)
        XCTAssertTrue(split.viewController(for: .secondary) === secondary)
        XCTAssertTrue(split.viewController(for: .supplementary) === supplementary)
    }
}
