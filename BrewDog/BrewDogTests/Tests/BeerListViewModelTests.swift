//
//  BeerListViewModelTests.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
import Nimble
@testable import BrewDog

class BeerServiceMock: BeerServiceProtocol {
    typealias ParamsAssertionType = (Int, Int) -> Void
    
    var beerList: BeerList?
    private var error: Error?
    var paramsAssertion: ParamsAssertionType?
    
    init(beerList: BeerList? = nil, error: Error? = nil, paramsAssertion: ParamsAssertionType? = nil) {
        self.beerList = beerList
        self.error = error
        self.paramsAssertion = paramsAssertion
    }
    
    func getBeerList(page: Int, perPage: Int, completion: @escaping ((() throws -> (BeerList)) -> Void)) {
        paramsAssertion?(page, perPage)
        if let error = error {
            completion { throw error }
        } else if let beerList = beerList {
            completion { beerList }
        }
    }
}

class BeerListViewModelDelegateMock: BeerListViewModelDelegate {
    typealias ModelWasFetchAssertionType = (BeerListViewModel) -> Void
    typealias ModelThrewErrorAssertionType = (BeerListViewModel, Error) -> Void
    private var modelWasFetchAssertion: ModelWasFetchAssertionType?
    private var modelThrewErrorAssertion: ModelThrewErrorAssertionType?
    
    init(modelWasFetchAssertion: ModelWasFetchAssertionType? = nil,
         modelThrewErrorAssertion: ModelThrewErrorAssertionType? = nil) {
        self.modelWasFetchAssertion = modelWasFetchAssertion
        self.modelThrewErrorAssertion = modelThrewErrorAssertion
    }
    
    func beerListViewModelWasFetch(_ viewModel: BeerListViewModel) {
        modelWasFetchAssertion?(viewModel)
    }
    
    func beerListViewModel(_ viewModel: BeerListViewModel, threw error: Error) {
        modelThrewErrorAssertion?(viewModel, error)
    }
}

class BeerListViewModelTests: BaseTests {
    func testSuccessfullFetch() {
        //Arrange
        let expectation = self.expectation(description: "Delegate was called")
        let beer = Beer(id: 12,
                        imageURL: "image url",
                        name: "name",
                        tagline: "tagline",
                        alcoholByVolume: 20,
                        internationalBitternessUnits: 10,
                        description: "description")
        let beerList = BeerList(beers: [beer])
        let beerServiceMock = BeerServiceMock(beerList: beerList)
        let vm = BeerListViewModel(beerService: beerServiceMock)
        let vmDelegate = BeerListViewModelDelegateMock(modelWasFetchAssertion: { viewModel in
            expectation.fulfill()
            XCTAssertTrue(viewModel === vm)
        })
        vm.delegate = vmDelegate
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
        expect(vm.beers.count).to(equal(beerList.beers.count))
        
        
        expect(vm.beers.count).to(equal(beerList.beers.count))
        expect(vm.beers.first?.id).to(equal(beer.id))
        expect(vm.beers.first?.imageURL).to(equal(beer.imageURL))
        expect(vm.beers.first?.name).to(equal(beer.name))
        expect(vm.beers.first?.tagline).to(equal(beer.tagline))
        expect(vm.beers.first?.abvString).to(equal("abv 20.0%"))
        expect(vm.beers.first?.ibuString).to(equal("ibu 10.0"))
        expect(vm.beers.first?.description).to(equal(beer.description))
    }
    
    func testErrorFetch() {
        //Arrange
        let expectation = self.expectation(description: "Delegate was called")
        let beerServiceMock = BeerServiceMock(error: BrewDogError.generic)
        let vm = BeerListViewModel(beerService: beerServiceMock)
        let vmDelegate = BeerListViewModelDelegateMock(modelThrewErrorAssertion: { viewModel, error in
            expectation.fulfill()
            expect(viewModel === vm).to(beTrue())
            guard case BrewDogError.generic = error else {
                XCTFail("Wrong error type")
                return
            }
        })
        vm.delegate = vmDelegate
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)

    }
    
    func testFetchParams() {
        //First page
        
        //Arrange
        var expectation = self.expectation(description: "Params first page assertion")
        let beerList = BeerList(beers: [Beer()])
        let beerServiceMock = BeerServiceMock(beerList: beerList) { (page, perPage) in
            expectation.fulfill()
            expect(page).to(equal(1))
            expect(perPage).to(equal(8))
        }
        let vm = BeerListViewModel(beerService: beerServiceMock)
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
        
        
        
        //Second page
        
        //Arrange
        expectation = self.expectation(description: "Params second page assertion")
        beerServiceMock.paramsAssertion = { (page, perPage) in
            expectation.fulfill()
            expect(page).to(equal(2))
            expect(perPage).to(equal(8))
        }
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
        
        
        //Refresh
        
        //Arrange
        expectation = self.expectation(description: "Params refresh assertion")
        beerServiceMock.paramsAssertion = { (page, perPage) in
            expectation.fulfill()
            expect(page).to(equal(1))
            expect(perPage).to(equal(8))
        }
        
        //Act
        vm.fetch(refresh: true)
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testCellsTypeWithLoading() {
        //Arrange
        let beer = Beer(id: 221,
                        imageURL: "image url",
                        name: "name",
                        tagline: "tagline",
                        alcoholByVolume: 20,
                        internationalBitternessUnits: 10,
                        description: "description")
        let beerList = BeerList(beers: [beer])
        let beerServiceMock = BeerServiceMock(beerList: beerList)
        let vm = BeerListViewModel(beerService: beerServiceMock)
        
        //Act
        vm.fetch()
        
        //Assert
        expect(vm.numberOfItens(in: 0)).to(equal(2))
        if case let BeerListViewModel.CellType.beer(bvm) = vm.cellType(at: IndexPath(row: 0, section: 0)),
            case BeerListViewModel.CellType.loading = vm.cellType(at: IndexPath(row: 1, section: 0)) {
            expect(bvm.id).to(equal(vm.beers.first?.id))
        } else {
            XCTFail("Wrong cell type at index")
        }
    }
    
    func testCellsTypeWithoutLoading() {
        //Arrange
        let beer = Beer(id: 221,
                        imageURL: "image url",
                        name: "name",
                        tagline: "tagline",
                        alcoholByVolume: 20,
                        internationalBitternessUnits: 10,
                        description: "description")
        let beerListFirstPage = BeerList(beers: [beer])
        let beerListSecondPage = BeerList(beers: [])
        let beerServiceMock = BeerServiceMock(beerList: beerListFirstPage)
        let vm = BeerListViewModel(beerService: beerServiceMock)
        
        //Act
        vm.fetch()
        beerServiceMock.beerList = beerListSecondPage
        vm.fetch()
        
        //Assert
        expect(vm.numberOfItens(in: 0)).to(equal(1))
        if case let BeerListViewModel.CellType.beer(bvm) = vm.cellType(at: IndexPath(row: 0, section: 0)) {
            expect(bvm.id).to(equal(vm.beers.first?.id))
        } else {
            XCTFail("Wrong cell type at index")
        }
    }
    
    func testCellsRefresh() {
        //Arrange
        let beer = Beer(id: 221,
                        imageURL: "image url",
                        name: "name",
                        tagline: "tagline",
                        alcoholByVolume: 20,
                        internationalBitternessUnits: 10,
                        description: "description")
        let beerListBeforeRefresh = BeerList(beers: [beer])
        let beerListAfterRefresh = BeerList(beers: [])
        let beerServiceMock = BeerServiceMock(beerList: beerListBeforeRefresh)
        let vm = BeerListViewModel(beerService: beerServiceMock)
        
        //Act
        vm.fetch()
        beerServiceMock.beerList = beerListAfterRefresh
        vm.fetch(refresh: true)
        
        //Assert
        expect(vm.numberOfItens(in: 0)).to(equal(0))
    }
}
