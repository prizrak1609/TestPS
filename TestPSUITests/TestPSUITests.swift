//
//  TestPSUITests.swift
//  TestPSUITests
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest

class TestPSUITests: XCTestCase {
        
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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true)
    }

    func testScroll() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.cells.allElementsBoundByIndex[0].swipeUp()
    }

    func testSearch() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let searchField = tablesQuery.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("Oni")
        tablesQuery.staticTexts["Beef - Ar - Oni (Quick)"].tap()
        app.buttons["Done"].tap()
        searchField.tap()
        tablesQuery.buttons["Cancel"].tap()
    }

    func testOpenURL() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Vegetable-Pasta Oven Omelet"].tap()
        app.buttons["Done"].tap()
    }
}
