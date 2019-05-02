//
//  BrewDogUITests.swift
//  BrewDogUITests
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import FBSnapshotTestCase

class BaseTests: FBSnapshotTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        XCUIDevice.shared.orientation = .portrait
        
        continueAfterFailure = true
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

extension BaseTests {
    func snapshot(element: XCUIElement, removingStatusBar: Bool = false) -> UIImageView {
        if removingStatusBar {
            let statusBar = XCUIApplication().statusBars.firstMatch
            return UIImageView(image: app.screenshot().image.removing(statusBar: statusBar))
        }
        
        return UIImageView(image: app.screenshot().image)
    }
}
