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
        sleep(3)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        app.terminate()
    }
    
    func testAAAOnboardingPage() throws {
        /* Test Case: Onboarding pages */
        // TODO: add a configuration to force starting with onboarding page

        XCTAssertTrue(app.buttons["Continue"].waitForExistence(timeout: 10)," Cannot find Continue button")
        app.buttons["Continue"].tap()

        XCTAssertTrue(app.buttons["Not now"].waitForExistence(timeout: 10), "Cannot find Activate button")
        app.buttons["Not now"].tap()

        XCTAssertTrue(app.buttons["Get started"].waitForExistence(timeout: 10), "Cannot find Get started button")
        app.buttons["Get started"].tap()


        XCTAssertTrue(app.buttons["ToDoList"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["ToDoList"].isHittable)
    }
    
    func testCreateATask() throws {
        /* Test Case: Create A Task */
        let testcase_title: String = "Test - Create A Task"
        XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Add Task"].isHittable)
        
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
        app.buttons["Priority"].tap()
        app.buttons["Low"].tap()
        app.buttons["EditTaskViewController.dateButton"].tap()
        
        // get the datePicker and set the target time at two days later
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d h mm a"
        let targetDate = Date().addingTimeInterval(87654*2)
        let targetDateArr = dateFormatter.string(from: targetDate).components(separatedBy: " ")
        
        app.datePickers.pickerWheels["Today"].adjust(toPickerWheelValue: targetDateArr[0]+" "+targetDateArr[1])
        
        let hourPredicator = NSPredicate(format: "value ENDSWITH 'clock'")
        app.datePickers.pickerWheels.element(matching: hourPredicator).adjust(toPickerWheelValue: targetDateArr[2])
        
        // handle singular and plural
        let minPredicator = NSPredicate(format: "value CONTAINS 'minute'")
        app.datePickers.pickerWheels.element(matching: minPredicator).adjust(toPickerWheelValue: targetDateArr[3])
        
        app.toolbars.buttons["Save"].tap()
        app.navigationBars["Add task"].buttons["Save"].tap()
        
        app.staticTexts["All Tasks"].tap()
        
        XCTAssertTrue(app.staticTexts[testcase_title].exists, "Cannot find target tasks, created failed")
        
        dateFormatter.dateFormat = "d MMM, HH:mm"
        let targetDateStr = dateFormatter.string(from: targetDate)
        XCTAssertTrue(app.staticTexts[targetDateStr].exists, "Cannot find datetime of target task")
        XCTAssertTrue(app.staticTexts["Low"].exists, "Cannot find priority of target task")
    }
    
    func testEditATask() throws {
        /* Test Case: Edit an exist task */
        let testcase_title: String = "Test - Edit A Task"
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
        app.navigationBars["Add task"].buttons["Save"].tap()
        
        app.staticTexts["All Tasks"].tap()
        app.staticTexts["Test - Edit A Task"].tap()
                
        app.buttons["Edit"].tap()
        
        XCTAssertTrue(app.navigationBars["Edit task"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Edit task"].exists, "Cannot get editing window")
        app.buttons["Priority"].tap()
        app.buttons["High"].tap()
        app.buttons["Save"].tap()
        XCTAssertTrue(app.staticTexts["High"].exists, "Fail to edit a task")
    }
    
    func testDeleteATask() throws {
        /* Test Case: Delete an exist task */
        let testcase_title: String = "Test - Delete A Task"
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
        app.navigationBars["Add task"].buttons["Save"].tap()
        
        app.staticTexts["All Tasks"].tap()
        app.staticTexts["Test - Delete A Task"].swipeLeft()

        app.buttons["Delete"].tap()

        XCTAssertFalse(app.staticTexts[testcase_title].exists, "Fail to delete a task")
    }
    
    func testCompleteATask() throws {
        /* Test Case: Complete a task */
        let testcase_title: String = "Test - Complete A Task"
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
        app.navigationBars["Add task"].buttons["Save"].tap()
        
        app.staticTexts["All Tasks"].tap()
        let cellPredicator = NSPredicate(format: "label CONTAINS 'Complete A Task'")
        let targetCell = app.cells.containing(cellPredicator)
        targetCell.buttons["complete task icon"].tap()
        XCTAssertFalse(app.staticTexts[testcase_title].exists, "Completed task is still in inbox")
        app.staticTexts["Task completed!"].swipeUp()
        app.buttons["Back"].tap()
        
        app.staticTexts["Completed"].tap()
        
        XCTAssertTrue(app.staticTexts[testcase_title].exists, "Cannot find the completed task")
    }
    
    func testResumeATask() throws {
        /* Test Case: Resume a task */
        let testcase_title: String = "Test - Resume A Task"
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
        app.navigationBars["Add task"].buttons["Save"].tap()
        
        app.staticTexts["All Tasks"].tap()
        let cellPredicator = NSPredicate(format: "label CONTAINS 'Resume A Task'")
        let targetCell = app.cells.containing(cellPredicator)
        targetCell.buttons["complete task icon"].tap()
        app.staticTexts["Task completed!"].swipeUp()
        app.buttons["Back"].tap()
        
        XCTAssertTrue(app.staticTexts["Completed"].waitForExistence(timeout: 10))
        app.staticTexts["Completed"].tap()
        XCTAssertTrue(app.staticTexts[testcase_title].exists, "Cannot find the completed task")
        
        app.staticTexts[testcase_title].tap()
        
        XCTAssertTrue(app.staticTexts["Task options"].waitForExistence(timeout: 10))
        app.buttons["Move to inbox"].tap()
        XCTAssertFalse(app.staticTexts[testcase_title].exists, "Cannot find the resumed task")
        
        app.buttons["Back"].tap()
        app.staticTexts["All Tasks"].tap()
        
        XCTAssertTrue(app.staticTexts[testcase_title].exists, "Cannot find the resumed task")
    }
    
    func testViewTasksInCustomInterval() {
        /* Test Case: View tasks in custom interval */
        let testcase_title: String = "Test - View Task in Custom Interval"
        app.buttons["Add Task"].tap()
        app.textViews["EditTaskViewController.taskTitleTextView"].typeText(testcase_title)
        app.buttons["EditTaskViewController.dateButton"].tap()
        
        // get the datePicker and set the target time at four days later
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let targetDate = Date().addingTimeInterval(87654*4)
        
        app.datePickers.pickerWheels["Today"].adjust(toPickerWheelValue: dateFormatter.string(from: targetDate))
        app.toolbars.buttons["Save"].tap()
        app.navigationBars["Add task"].buttons["Save"].tap()
        
        app.staticTexts["Custom Interval"].tap()
        
        XCTAssertTrue(app.staticTexts["Select Date Interval"].exists, "Date interval picker doesn't show correctly")
        dateFormatter.dateFormat = "dd MMM YY"
        let tomorrowDate = dateFormatter.string(from: Date().addingTimeInterval(86400))
        let intervalBoundDate = dateFormatter.string(from: Date().addingTimeInterval(87654*5))
        app.pickerWheels[tomorrowDate].adjust(toPickerWheelValue: intervalBoundDate)
        
        app.toolbars.buttons["Done"].tap()
        
        XCTAssertTrue(app.staticTexts[testcase_title].exists, "Cannot find tasks in target interval")
    }
    
    func testChangeThemeColor() throws {
        /* Test Case: Change theme color */
        app.buttons["settingsIcon"].tap()
        XCTAssertFalse(app.staticTexts["Skirret Green"].exists, "Target color theme shows before being selected")
        app.staticTexts["Theme"].tap()
        app.staticTexts["Skirret Green"].tap()
        app.buttons["OK"].tap()
        app.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Skirret Green"].exists, "Target color theme is not selected successfully")
    }
}
