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
        static let visibleBeerLoadText = "Buzz"
        static let notVisibleBeerLoadText = "Bramling X"
    }
    
    static var screen: XCUIElement {
        return XCUIApplication().collectionViews["BeerListScreen"]
    }
    
    static func visibleBeerCell() -> XCUIElement {
        return screen.cells.containing(.staticText, identifier: ElementsIds.visibleBeerLoadText).firstMatch
    }
    
    static func notVisibleBeerCell() -> XCUIElement {
        return screen.cells.containing(.staticText, identifier: ElementsIds.notVisibleBeerLoadText).firstMatch
    }
}
