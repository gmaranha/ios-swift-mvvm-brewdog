//
//  BeerViewModelTests.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
import Nimble
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
        expect(vm.id).to(equal(beer.id))
        expect(vm.imageURL).to(equal(beer.imageURL))
        expect(vm.name).to(equal(beer.name))
        expect(vm.tagline).to(equal(beer.tagline))
        expect(vm.abvString).to(equal("abv 20.0%"))
        expect(vm.ibuString).to(equal("ibu 10.0"))
        expect(vm.description).to(equal(beer.description))
    }
}
