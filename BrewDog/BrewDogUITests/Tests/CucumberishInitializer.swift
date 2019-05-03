//
//  CucumberishInitializer.swift
//  BrewDogUITests
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import FBSnapshotTestCase
import Cucumberish
import Nimble
import Nimble_Snapshots

class CucumberishInitializer: NSObject {
    @objc class func setupCucumberish() {
        let app = XCUIApplication()
        
        before({ _ in
            XCUIDevice.shared.orientation = .portrait
            app.launch()
        })
        
        Given("I am on beer list screen") { (_, _) -> Void in
            waitElementExists(BeerListScreen.screen)
        }
        
        Then("I should see the list of beers") { (_, _) -> Void in
//            let beerListBeforeImageView = BeerListScreen.screen.snapshot(in: app, removingStatusBar: true)
            waitElementExists(BeerListScreen.notVisibleBeerCell(), scrollElement: BeerListScreen.screen, timeout: 2)
//            let beerListAfterImageView = BeerListScreen.screen.snapshot(in: app, removingStatusBar: true)
            
//            expect(beerListBeforeImageView).to(haveValidSnapshot(identifier: "before"))
//            expect(beerListAfterImageView).to(haveValidSnapshot(identifier: "after"))
        }
        
        Then("I should see the beer details") { (_, _) -> Void in
            waitElementExists(BeerScreen.screen)
//            let beerImageView = BeerListScreen.screen.snapshot(in: app, removingStatusBar: true)
            
//            expect(beerImageView).to(haveValidSnapshot(identifier: "beerScreen"))
        }
        
        When("I select a beer") { (_, _) -> Void in
            let cell = BeerListScreen.notVisibleBeerCell()
            waitElementExists(cell, scrollElement: BeerListScreen.screen, timeout: 2)
            cell.tap()
        }
        
        When("I tap back") { (_, _) -> Void in
            BeerScreen.tapNavigationBackButton()
        }
        
        When("I pull to refresh") { (_, _) -> Void in
            let cell = BeerListScreen.visibleBeerCell()
            
            let start = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            let finish = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 2.5))
            start.press(forDuration: 0, thenDragTo: finish)
        }
        
        
        Cucumberish.executeFeatures(inDirectory: "Features", from: Bundle(for: CucumberishInitializer.self), includeTags: nil, excludeTags: nil)
    }
    
    /// Wait an element exists to start interact with it.
    ///
    /// - Parameters:
    ///   - element: Current element
    ///   - scrollElement: Elemento to scroll to search
    ///   - timeout: Optional timeout. Default value is 10 seconds.
    ///   - scrollAttempts: Attempts. Default is 3
    class func waitElementExists(_ element: XCUIElement,
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


extension XCUIElement {
    func snapshot(in app: XCUIApplication, removingStatusBar: Bool = false) -> UIImageView {
        if removingStatusBar {
            let statusBar = XCUIApplication().statusBars.firstMatch
            return UIImageView(image: app.screenshot().image.removing(statusBar: statusBar))
        }
        
        return UIImageView(image: self.screenshot().image)
    }
}
