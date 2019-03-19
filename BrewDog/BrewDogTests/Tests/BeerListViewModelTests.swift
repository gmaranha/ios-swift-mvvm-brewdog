//
//  BeerListViewModelTests.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
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
        if let error = self.error {
            completion { throw error }
        } else if let beerList = self.beerList {
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
        self.waitForExpectations(timeout: 1)
        XCTAssertEqual(vm.beers.count, beerList.beers.count)
        XCTAssertEqual(vm.beers.first?.id, beer.id)
        XCTAssertEqual(vm.beers.first?.imageURL, beer.imageURL)
        XCTAssertEqual(vm.beers.first?.name, beer.name)
        XCTAssertEqual(vm.beers.first?.tagline, beer.tagline)
        XCTAssertEqual(vm.beers.first?.abvString, "abv 20.0%")
        XCTAssertEqual(vm.beers.first?.ibuString, "ibu 10.0")
        XCTAssertEqual(vm.beers.first?.description, beer.description)
    }
    
    func testErrorFetch() {
        //Arrange
        let expectation = self.expectation(description: "Delegate was called")
        let beerServiceMock = BeerServiceMock(error: BrewDogError.generic)
        let vm = BeerListViewModel(beerService: beerServiceMock)
        let vmDelegate = BeerListViewModelDelegateMock(modelThrewErrorAssertion: { viewModel, error in
            expectation.fulfill()
            XCTAssertTrue(viewModel === vm)
            guard case BrewDogError.generic = error else {
                XCTFail("Wrong error type")
                return
            }
        })
        vm.delegate = vmDelegate
        
        //Act
        vm.fetch()
        
        //Assert
        self.waitForExpectations(timeout: 1)

    }
    
    func testFetchParams() {
        //First page
        
        //Arrange
        var expectation = self.expectation(description: "Params first page assertion")
        let beerList = BeerList(beers: [Beer()])
        let beerServiceMock = BeerServiceMock(beerList: beerList) { (page, perPage) in
            expectation.fulfill()
            XCTAssertEqual(page, 1)
            XCTAssertEqual(perPage, 8)
        }
        let vm = BeerListViewModel(beerService: beerServiceMock)
        
        //Act
        vm.fetch()
        
        //Assert
        self.waitForExpectations(timeout: 1)
        
        
        
        //Second page
        
        //Arrange
        expectation = self.expectation(description: "Params second page assertion")
        beerServiceMock.paramsAssertion = { (page, perPage) in
            expectation.fulfill()
            XCTAssertEqual(page, 2)
            XCTAssertEqual(perPage, 8)
        }
        
        //Act
        vm.fetch()
        
        //Assert
        self.waitForExpectations(timeout: 1)
        
        
        
        //Refresh
        
        //Arrange
        expectation = self.expectation(description: "Params refresh assertion")
        beerServiceMock.paramsAssertion = { (page, perPage) in
            expectation.fulfill()
            XCTAssertEqual(page, 1)
            XCTAssertEqual(perPage, 8)
        }
        
        //Act
        vm.fetch(refresh: true)
        
        //Assert
        self.waitForExpectations(timeout: 1)
    }
    
    func testCellsTypeWithLoading() {
        //First page
        
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
        XCTAssertEqual(vm.numberOfItens(in: 0), 2)
        if case let BeerListViewModel.CellType.beer(bvm) = vm.cellType(at: IndexPath(row: 0, section: 0)),
            case BeerListViewModel.CellType.loading = vm.cellType(at: IndexPath(row: 1, section: 0)) {
            XCTAssertEqual(bvm.id, vm.beers.first?.id)
        } else {
            XCTFail("Wrong cell type at index")
        }
    }
    
    func testCellsTypeWithoutLoading() {
        //First page
        
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
        XCTAssertEqual(vm.numberOfItens(in: 0), 1)
        if case let BeerListViewModel.CellType.beer(bvm) = vm.cellType(at: IndexPath(row: 0, section: 0)) {
            XCTAssertEqual(bvm.id, vm.beers.first?.id)
        } else {
            XCTFail("Wrong cell type at index")
        }
    }
    
    func testCellsRefresh() {
        //First page
        
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
        vm.fetch(refresh: true)
        
        //Assert
        XCTAssertEqual(vm.numberOfItens(in: 0), 0)
    }
}
