//
//  BaseScreen.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 11/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest

protocol BaseScreen {
    
    /// Screen ui element
    static var screen: XCUIElement { get }
    
//    /// Waits screen to be shown
//    ///
//    /// - Parameter testCase: test case use to assert the screen presentation
//    static func waitScreen(testCase: XCTestCase)
}

// MARK: - Common
extension BaseScreen {
    
    /// Waits screen to be shown
    ///
    /// - Parameter testCase: test case use to assert the screen presentation
    static func waitScreen(testCase: XCTestCase) {
        testCase.waitElementExists(element: screen)
    }
    
    /// Tap button
    ///
    /// - Parameter identifier: button identifier
    static func tapButton(identifier: String) {
        XCUIApplication().buttons[identifier].tap()
    }
    
    /// Tap cell
    ///
    /// - Parameter identifier: cell identifier
    static func tapCell(identifier: String) {
        XCUIApplication().tables.cells.staticTexts[identifier].tap()
    }
    
    /// Tap Navigation back button
    ///
    /// - Parameter identifier: Navagation identifier
    static func tapNavigationBackButton(navigationIdentifier: String, backIdentifier: String = "Back") {
        XCUIApplication().navigationBars[navigationIdentifier].buttons[backIdentifier].tap()
    }
}
