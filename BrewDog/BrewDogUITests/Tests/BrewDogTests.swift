//
//  BeerListTests.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 11/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
import Nimble
import Nimble_Snapshots

class BrewDogTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        BeerListScreen.waitScreen(testCase: self)
    }
    
    func testCollectionScroll() {
        let beerListBeforeImageView = snapshot(element: BeerListScreen.screen, removingStatusBar: true)
        waitElementExists(element: BeerListScreen.notVisibleBeerCell(), scrollElement: BeerListScreen.screen, timeout: 2)
        let beerListAfterImageView = snapshot(element: BeerListScreen.screen, removingStatusBar: true)
        
        expect(beerListBeforeImageView).to(haveValidSnapshot(identifier: "before"))
        expect(beerListAfterImageView).to(haveValidSnapshot(identifier: "after"))
    }
    
    func testDetails() {
        let cell = BeerListScreen.notVisibleBeerCell()
        waitElementExists(element: cell, scrollElement: BeerListScreen.screen, timeout: 2)
        cell.tap()
        BeerScreen.waitScreen(testCase: self)
        let beerImageView = snapshot(element: BeerListScreen.screen, removingStatusBar: true)
        
        BeerScreen.tapNavigationBackButton()
        BeerListScreen.waitScreen(testCase: self)
        let beerListImageView = snapshot(element: BeerListScreen.screen, removingStatusBar: true)
        
        expect(beerImageView).to(haveValidSnapshot(identifier: "beerScreen"))
        expect(beerListImageView).to(haveValidSnapshot(identifier: "beerListScreen"))
    }
    
    func testCollectionRefresh() {
        let cell = BeerListScreen.visibleBeerCell()
        let screen = BeerListScreen.screen
        
        let start = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 2.5))
        start.press(forDuration: 0, thenDragTo: finish)
        
        waitElementExists(element: cell, scrollElement: screen)
    }
}
