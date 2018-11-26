//
//  UITests.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 16.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCTest

class XCoordinator_ExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Recents"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Example article 3"]/*[[".cells.staticTexts[\"Example article 3\"]",".staticTexts[\"Example article 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["XCoordinator_Example.NewsDetailView"].buttons["QuickBird Studios Blog"].tap()
        tabBarsQuery.buttons["More"].tap()
        app.buttons["Users"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Sebi"]/*[[".cells.staticTexts[\"Sebi\"]",".staticTexts[\"Sebi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Show alert"].tap()
        app.alerts["Hey"].buttons["Ok"].tap()
        app.navigationBars["XCoordinator_Example.UserView"].buttons["Close"].tap()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
