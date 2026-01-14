//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Christian Bonilla on 06/01/26.
//

import XCTest

final class ToDoUITests: XCTestCase {

    let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testLaunchInEnglish() {
        app.launchArguments += ["-resetLanguage"]
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launch()
        
        let header = app.staticTexts["Select the working profile"]
        XCTAssertTrue(header.exists, "The header \"Select the working profile\" is not displayed")
    }
    
    func testLaunchInSpanish() {
        app.launchArguments += ["-resetLanguage"]
        app.launchArguments += ["-AppleLanguages", "(es)"]
        app.launch()
        
        let header = app.staticTexts["Selecciona un perfil"]
        XCTAssertTrue(header.exists, "The header \"Selecciona un perfil\" is not displayed")
    }
    
    func testNewGroupCreation() {
        app.launchArguments += ["-resetLanguage"]
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launch()
        
        let firstProfile = app.buttons.firstMatch
        if firstProfile.exists {
            firstProfile.tap()
            
            let addButton = app.buttons["addGroupButton"]
            if addButton.waitForExistence(timeout: 2) {
                addButton.tap()
                
                XCTAssertTrue(app.staticTexts["Group Name"].exists)
                XCTAssertTrue(app.staticTexts["Select Icon"].exists)
            }
        }
    }
}
