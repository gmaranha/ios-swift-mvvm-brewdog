//
//  XCTestCase+Extensions.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 11/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
import Nimble

extension XCTestCase {
    /// Wait an element exists to start interact with it.
    ///
    /// - Parameters:
    ///   - element: Current element
    ///   - scrollElement: Elemento to scroll to search
    ///   - timeout: Optional timeout. Default value is 10 seconds.
    ///   - scrollAttempts: Attempts. Default is 3
    func waitElementExists(element: XCUIElement,
                           scrollElement: XCUIElement? = nil,
                           timeout: TimeInterval = 5,
                           scrollAttempts: Int = 3) {
        
        var exists = element.waitForExistence(timeout: timeout)
        
        if let scrollElement = scrollElement {
            for _ in 2...scrollAttempts {
                if exists {
                    return
                }

                scrollElement.swipeUp()
                
                exists = element.waitForExistence(timeout: timeout)
            }
        }
        
        expect(exists).to(beTrue(), description: "Element \"\(element)\" was not found")
    }
}
