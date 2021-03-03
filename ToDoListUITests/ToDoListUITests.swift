//
//  ToDoListUITests.swift
//  ToDoListUITests
//
//  Created by denys zelenchuk on 03.09.20.
//  Copyright © 2020 Radu Ursache - RanduSoft. All rights reserved.
//

import XCTest
import UIKit

class ToDoListUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
        
        // TODO: temp holder, escape from being blocked due to no icloud connection
        sleep(5)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
//    func testOnboardingPage() throws {
//        // TODO: add a configuration to force starting with onboarding page
//
//        XCTAssertTrue(app.buttons["Continue"].waitForExistence(timeout: 10)," Cannot find Continue button")
//        app.buttons["Continue"].tap()
//
//        XCTAssertTrue(app.buttons["Not now"].waitForExistence(timeout: 10), "Cannot find Activate button")
//        app.buttons["Not now"].tap()
//
//        XCTAssertTrue(app.buttons["Get started"].waitForExistence(timeout: 10), "Cannot find Get started button")
//        app.buttons["Get started"].tap()
//
//
//        XCTAssertTrue(app.buttons["ToDoList"].waitForExistence(timeout: 10))
//        XCTAssertTrue(app.buttons["ToDoList"].isHittable)
//    }
    
    func testCreateATask() throws {
        
        XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Add Task"].isHittable)
        
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText("Test Task")
        app.buttons["Priority"].tap()
        app.buttons["High"].tap()
        app.buttons["EditTaskViewController.dateButton"].tap()
        
        // get the datePicker and set the target time at two days later
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d h m a"
        let targetDateArr = dateFormatter.string(from: Date().addingTimeInterval(87654*2)).components(separatedBy: " ")
        
        app.datePickers.pickerWheels["Today"].adjust(toPickerWheelValue: targetDateArr[0]+" "+targetDateArr[1])
        
        let hourPredicator = NSPredicate(format: "value ENDSWITH 'clock'")
        app.datePickers.pickerWheels.element(matching: hourPredicator).adjust(toPickerWheelValue: targetDateArr[2])
        let minPredicator = NSPredicate(format: "value ENDSWITH 'minutes'")
        app.datePickers.pickerWheels.element(matching: minPredicator).adjust(toPickerWheelValue: targetDateArr[3])
        
        app.toolbars.buttons["Save"].tap()
        app.navigationBars["Add task"].buttons["Save"].tap()
    }
}
