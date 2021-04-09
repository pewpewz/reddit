//
//  StockXUITests.swift
//  StockXUITests
//
//  Created by terrylee on 4/9/21.
//

import XCTest

class StockXUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testInitialLoad() {
        let app = XCUIApplication()
        app.launch()
        wait(1)
        XCTAssertEqual(app.tables.cells.count, 25, "There should be 25 posts")
    }
    
    func testSearchButton() {
        let app = XCUIApplication()
        app.launch()
        wait(1)
        let searchField = app.textFields["searchSubreddit"]
        searchField.tap()
        searchField.typeText("funny")
        let searchButton = app.navigationBars.buttons["Search"]
        searchButton.tap()
        wait(1)
        let cell = app.tables.cells["PostCell_2"]
        cell.tap()
        wait(3)
        app.swipeDown(velocity: .fast)
        wait(1)
        XCTAssert(app.tables.cells["PostCell_3"].exists)
    }
}

extension XCTestCase {
    func wait(_ timeout: Double) {
        let expection = self.expectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            expection.fulfill()
        }
        waitForExpectations(timeout: timeout + 1)
    }
}
