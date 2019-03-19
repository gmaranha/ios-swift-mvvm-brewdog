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
}

// MARK: - Common
extension BaseScreen {
    
    /// Waits screen to be shown
    ///
    /// - Parameter testCase: test case use to assert the screen presentation
    static func waitScreen(testCase: XCTestCase) {
        testCase.waitElementExists(element: screen)
    }
    
    /// Tap Navigation back button
    static func tapNavigationBackButton() {
        XCUIApplication().navigationBars.buttons.firstMatch.tap()
    }
}
