//
//  ToDoListUIBenchmark.swift
//  ToDoListUITests
//
//  Created by Haokuang Tsai on 2021/3/4.
//  Copyright © 2021 Radu Ursache - RanduSoft. All rights reserved.
//

import XCTest

class ToDoListUIBenchmark: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
        
        // TODO: temp holder, escape from being blocked due to no icloud connection
        sleep(5)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateATaskBenchmark() throws {
        /* Test Case: Create A Task */
        // disable Hardware keyboard if you are running with a simulator
        let testcase_title: String = "Test - Create A Task"
        XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 10))
        
        // get the datePicker and set the target time at two days later
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d h mm a"
        let targetDate = Date().addingTimeInterval(87654*2)
        let targetDateArr = dateFormatter.string(from: targetDate).components(separatedBy: " ")
        
        self.measure {
            app.buttons["Add Task"].tap()
            app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
            app.buttons["Priority"].tap()
            app.buttons["Low"].tap()
            app.buttons["EditTaskViewController.dateButton"].tap()
            
            app.datePickers.pickerWheels["Today"].adjust(toPickerWheelValue: targetDateArr[0]+" "+targetDateArr[1])
            
            let hourPredicator = NSPredicate(format: "value ENDSWITH 'clock'")
            app.datePickers.pickerWheels.element(matching: hourPredicator).adjust(toPickerWheelValue: targetDateArr[2])
            
            // handle singular and plural
            let minPredicator = NSPredicate(format: "value CONTAINS 'minute'")
            app.datePickers.pickerWheels.element(matching: minPredicator).adjust(toPickerWheelValue: targetDateArr[3])
            
            app.toolbars.buttons["Save"].tap()
            app.navigationBars["Add task"].buttons["Save"].tap()
            XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 10))
        }
    }
}
