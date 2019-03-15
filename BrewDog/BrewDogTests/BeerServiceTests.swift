//
//  BrewDogTests.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
@testable import BrewDog

class URLSessionMock: BaseMock, BrewDogURLSession {
    var urlAssertBlock: ((URL?) -> Void)?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlAssertBlock?(url)
        do {
            let data = try loadResponse()
            completionHandler(data, nil, nil)
        } catch {
            completionHandler(nil, nil, error)
        }
    }
}

class BeerServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNotReachable() {
        //Arrange
        let urlSessionMock = URLSessionMock.init()
        let expectation = self.expectation(description: "Expect generic error")
        
        let service = BeerService(session: urlSessionMock, reachability: ReachabilityMock(reachable: false))
        
        //Act
        service.getBeerList(page: 1, perPage: 1) { callback in
            do {
                _ = try callback()
            } catch BrewDogError.offlineMode {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        self.waitForExpectations(timeout: 1)
    }
    
    
    
    func testApiError() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "Beer", error: BrewDogError.generic)
        let expectation = self.expectation(description: "Expect generic error")
        
        let service = BeerService(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBeerList(page: 1, perPage: 1) { callback in
            do {
                _ = try callback()
            } catch BrewDogError.generic {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        self.waitForExpectations(timeout: 1)
    }
    
    func testParseError() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "BeerParseError")
        let expectation = self.expectation(description: "Expect parse error")
        
        let service = BeerService(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBeerList(page: 1, perPage: 1) { callback in
            do {
                _ = try callback()
            } catch BrewDogError.parse {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        self.waitForExpectations(timeout: 1)
    }
    
    func testSuccess() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "Beer")
        let expectation = self.expectation(description: "Expect success")
        
        let service = BeerService(session: urlSessionMock, reachability: ReachabilityMock())
        var beerList: BeerList!
        //Act
        service.getBeerList(page: 1, perPage: 1) { callback in
            do {
                beerList = try callback()
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        self.waitForExpectations(timeout: 1)
        XCTAssertEqual(beerList.beers.count, 1)
        XCTAssertEqual(beerList.beers[0].id, 1)
        XCTAssertEqual(beerList.beers[0].imageURL, "https://images.punkapi.com/v2/keg.png")
        XCTAssertEqual(beerList.beers[0].name, "Buzz")
        XCTAssertEqual(beerList.beers[0].tagline, "A Real Bitter Experience.")
        XCTAssertEqual(beerList.beers[0].alcoholByVolume, 4.5)
        XCTAssertEqual(beerList.beers[0].internationalBitternessUnits, 60.0)
        XCTAssertEqual(beerList.beers[0].description, "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.")
    }
    
    func testGeneratedURL() {
        //Arrange
        let expectation = self.expectation(description: "URL assertion")
        let urlSessionMock = URLSessionMock.init(file: "Beer", error: BrewDogError.offlineMode)
                urlSessionMock.urlAssertBlock = {url in
                    expectation.fulfill()
                    XCTAssertEqual(url?.absoluteString, "https://api.punkapi.com/v2/beers?page=2&per_page=4")
                }
        
        let service = BeerService(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBeerList(page: 2, perPage: 4) { _ in }
        
        //Assert
        self.waitForExpectations(timeout: 1)
    }
}
