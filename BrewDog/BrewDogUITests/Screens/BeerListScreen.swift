//
//  BeerListScreen.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 11/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest

class BeerListScreen: BaseScreen {
    private struct ElementsIds {
        static let beerLoadText = "Buzz"
    }
    
    static var screen: XCUIElement {
        return XCUIApplication().collectionViews["BeerListScreen"]
    }
    
    static func beerCell() -> XCUIElement {
        let cell = screen.cells.element(boundBy: 0).staticTexts[ElementsIds.beerLoadText]
        return cell
    }
}
