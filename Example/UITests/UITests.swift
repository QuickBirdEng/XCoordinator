//
//  UITests.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest

// swiftlint:disable:next type_name
class XCoordinator_ExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation -
        // required for your tests before they run. The setUp method is a good place to do this.
    }

    func testNavigation() {
        let app = XCUIApplication()
        clickThroughTabHomeFromLogin(app: app)
        clickThroughSplitHomeFromLogin(app: app)
        clickThroughPageHomeFromLogin(app: app)
    }

    // MARK: - Helpers

    private func clickThroughPageHomeFromLogin(app: XCUIApplication) {
        app.buttons["Login"].tap()
        app.swipeLeft()
        clickThroughNewsDetailScreenFromNews(app: app, trySwiping: false)
        app.swipeRight()
        clickThroughUserScreenFromHome(app: app)
        app.buttons["Logout"].tap()
    }

    private func clickThroughSplitHomeFromLogin(app: XCUIApplication) {
        app.buttons["Login"].tap()
        clickThroughNewsDetailScreenFromNews(app: app, trySwiping: true)
        app.navigationBars.buttons["Home"].tap()
        clickThroughUserScreenFromHome(app: app)
        app.buttons["Logout"].tap()
    }

    private func clickThroughTabHomeFromLogin(app: XCUIApplication) {
        app.buttons["Login"].tap()
        app.tabBars.buttons["Recents"].tap()
        clickThroughNewsDetailScreenFromNews(app: app, trySwiping: true)
        app.tabBars.buttons["More"].tap()
        clickThroughUserScreenFromHome(app: app)
        app.buttons["Logout"].tap()
    }

    private func clickThroughNewsDetailScreenFromNews(app: XCUIApplication, trySwiping: Bool) {
        app.tables.staticTexts["Example article 0"].tap()
        if trySwiping {
            let window = app.children(matching: .window).element(boundBy: 1)
            window.edgeSwipeLeft()
            app.tables.staticTexts["Example article 0"].tap()
        }
        app.navigationBars.buttons["QuickBird Studios Blog"].tap()
    }

    private func clickThroughUserScreenFromHome(app: XCUIApplication) {
        app.buttons["Users"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Stefan"]/*[[".cells.staticTexts[\"Stefan\"]",".staticTexts[\"Stefan\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Show alert"].tap()
        app.alerts["Hey"].buttons["Ok"].tap()
        let window = app.children(matching: .window).element(boundBy: 1)
        window.edgeSwipeRight()
        app.navigationBars.buttons["Back"].tap()
        window.edgeSwipeRight()
        window.edgeSwipeLeft()
        app.navigationBars.buttons["Close"].tap()
        app.navigationBars.buttons["Home"].tap()
    }
}
