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
        let app = XCUIApplication()
        let alert = app.alerts["Choose your email address"]
        snapshot("02Settings")
        
        alert.textFields.allElementsBoundByIndex.first?.typeText("your@email.com")
        alert.buttons.allElementsBoundByIndex.first?.tap()
        snapshot("01Main")
    }
    
}
