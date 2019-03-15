//
//  BeerViewModelTests.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
@testable import BrewDog

class BeerViewModelTests: BaseTests {
    
    func testViewModelInit() {
        //Arrange
        let beer = Beer(id: 12,
                        imageURL: "image url",
                        name: "name",
                        tagline: "tagline",
                        alcoholByVolume: 20,
                        internationalBitternessUnits: 10,
                        description: "description")
        
        //Act
        let vm = BeerViewModel(beer)

        //Assert
        XCTAssertEqual(vm.id, beer.id)
        XCTAssertEqual(vm.imageURL, beer.imageURL)
        XCTAssertEqual(vm.name, beer.name)
        XCTAssertEqual(vm.tagline, beer.tagline)
        XCTAssertEqual(vm.abvString, "abv 20.0%")
        XCTAssertEqual(vm.ibuString, "ibu 10.0")
        XCTAssertEqual(vm.description, beer.description)
    }
}
