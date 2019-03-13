//
//  XCTestCase+Extensions.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 11/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Wait an element exists to start interact with it.
    ///
    /// - Parameters:
    ///   - element: Current element
    ///   - timeout: Optional timeout. Default value is 10 seconds.
    func waitElementExists(element: XCUIElement, timeout: TimeInterval = 5) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Element \"\(element)\" was not found")
//        let exists = NSPredicate { (element, _) -> Bool in
//            (element as? XCUIElement)?.exists ?? false
//        }
//
//        expectation(for: exists, evaluatedWith: element, handler: nil)
//        waitForExpectations(timeout: timeout, handler: nil)
    }
}
