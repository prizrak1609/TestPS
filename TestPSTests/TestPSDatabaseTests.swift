//
//  TestPSDatabaseTests.swift
//  TestPS
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest
@testable import TestPS

class TestPSDatabaseTests: XCTestCase {

    var database: Database! = nil
    
    override func setUp() {
        super.setUp()
        database = Database()
        testOpenOrCreate()
    }
    
    override func tearDown() {
        testDeleteReceipes()
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true)
    }

    func testOpenOrCreate() {
        let openResult = database.openOrCreate()
        switch openResult {
            case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
            case .success(_): XCTAssertTrue(true)
        }
    }

    func testDeleteReceipes() {
        testOpenOrCreate()
        let result = database.deleteReceipes()
        switch result {
            case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
            case .success(_): XCTAssertTrue(true)
        }
    }

    func testGetRecipes() {
        testOpenOrCreate()
        let receipesResult = database.getAllReceipes()
        switch receipesResult {
            case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
            case .success(let models): XCTAssertTrue(models.isEmpty)
        }
    }

    func testSaveRecipes() {
        testOpenOrCreate()
        var receipe = RecipeModel()
        receipe.title = "t"
        receipe.thumbnail = "th"
        receipe.siteURLPath = "s"
        receipe.ingredients = "i"
        let saveResult = database.create(recipes: [receipe])
        switch saveResult {
            case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
            case .success(_): XCTAssertTrue(true)
        }
        let receipesResult = database.getAllReceipes()
        var model = RecipeModel()
        switch receipesResult {
            case .failure(let error): XCTAssertTrue(false, error.localizedDescription)
            case .success(let models):
                XCTAssertFalse(models.isEmpty)
                model = models[0]
        }
        XCTAssertTrue(model.title == receipe.title)
        XCTAssertTrue(model.thumbnail == receipe.thumbnail)
        XCTAssertTrue(model.siteURLPath == receipe.siteURLPath)
        XCTAssertTrue(model.ingredients == receipe.ingredients)
    }
}
