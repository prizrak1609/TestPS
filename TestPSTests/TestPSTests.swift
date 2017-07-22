//
//  TestPSTests.swift
//  TestPSTests
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest
@testable import TestPS

class TestPSTests: XCTestCase {

    var server: Server! = nil
    
    override func setUp() {
        super.setUp()
        server = Server(delegate: nil)
    }
    
    override func tearDown() {
        server = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true)
    }

    func testGetReceipesWithoutSearchString() {
        let expect = expectation(description: "get receipes without search string")
        expect.expectedFulfillmentCount = 2
        var models = [RecipeModel]()
        server.getReceipts { result in
            switch result {
                case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
                case .success(let _models):
                    models = _models
                    expect.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertFalse(models.isEmpty)
    }

    func testGetReceipesWithSearchString() {
        let expect = expectation(description: "get receipes without search string")
        expect.expectedFulfillmentCount = 2
        var models = [RecipeModel]()
        server.getReceipts(text: "Omelet") { result in
            switch result {
            case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
            case .success(let _models):
                models = _models
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertFalse(models.isEmpty)
    }
}
