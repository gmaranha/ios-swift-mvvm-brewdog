//
//  BeerListTests.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 11/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest

class BrewDogTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        BeerListScreen.waitScreen(testCase: self)
    }
    
    func testCollectionDidLoad() {
        waitElementExists(element: BeerListScreen.beerCell())
    }
    
    func testDetails() {
        let cell = BeerListScreen.beerCell()
        waitElementExists(element: cell)
        cell.tap()
        BeerScreen.waitScreen(testCase: self)
    }
}
