//
//  MajorKeyUITests.swift
//  MajorKeyUITests
//
//  Created by Felix Krause on 8/22/18.
//  Copyright © 2018 Felix Krause. All rights reserved.
//

import XCTest

class MajorKeyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLaunch() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        snapshot("0Launch")
    }
    
}
