//
//  BeerScreen.swift
//  BrewDogUITests
//
//  Created by Giuliano Maranha on 12/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest

class BeerScreen: BaseScreen {
    static var screen: XCUIElement {
        return XCUIApplication().otherElements["BeerScreen"]
    }
}
