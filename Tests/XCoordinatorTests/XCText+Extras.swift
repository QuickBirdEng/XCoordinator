//
//  XCText+Extras.swift
//  XCoordinator_Tests
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import UIKit
import XCTest

extension XCTestCase {

    /// Creates a window attached to the host app's foreground `UIWindowScene`.
    ///
    /// UIKit only renders windows that belong to an active scene, and navigation
    /// push/pop animations only run (and call their completion) when the controller
    /// is actually on screen. A bare `UIWindow()` has no scene and never renders,
    /// so the tests use the scene provided by the test-host application.
    @MainActor
    func makeWindow() -> UIWindow {
        let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = windowScenes.first { $0.activationState == .foregroundActive } ?? windowScenes.first
        if let scene {
            return UIWindow(windowScene: scene)
        }
        return UIWindow(frame: UIScreen.main.bounds)
    }

    func asyncWait(for timeInterval: TimeInterval) {
        let waitExpectation = self.expectation(description: "WAIT \(Date().timeIntervalSince1970)")
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + timeInterval) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: max(timeInterval * 2, 1))
    }

}
