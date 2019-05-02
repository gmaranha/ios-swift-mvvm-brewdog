//
//  BrewDogTests.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import XCTest
import Nimble
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

class BeerServiceTests: BaseTests {

    override func setUp() {
    }

    override func tearDown() {
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
        waitForExpectations(timeout: 1)
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
        waitForExpectations(timeout: 1)
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
        waitForExpectations(timeout: 1)
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
        waitForExpectations(timeout: 1)
        expect(beerList.beers.count).to(equal(1))
        expect(beerList.beers[0].id).to(equal(1))
        expect(beerList.beers[0].imageURL).to(equal("https://images.punkapi.com/v2/keg.png"))
        expect(beerList.beers[0].name).to(equal("Buzz"))
        expect(beerList.beers[0].tagline).to(equal("A Real Bitter Experience."))
        expect(beerList.beers[0].alcoholByVolume).to(equal(4.5))
        expect(beerList.beers[0].internationalBitternessUnits).to(equal(60.0))
        expect(beerList.beers[0].description).to(equal("A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once."))
    }
    
    func testGeneratedURL() {
        //Arrange
        let expectation = self.expectation(description: "URL assertion")
        let urlSessionMock = URLSessionMock.init(file: "Beer", error: BrewDogError.offlineMode)
                urlSessionMock.urlAssertBlock = {url in
                    expectation.fulfill()
                    expect(url?.absoluteString).to(equal("https://api.punkapi.com/v2/beers?page=2&per_page=4"))
                }
        
        let service = BeerService(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBeerList(page: 2, perPage: 4) { _ in }
        
        //Assert
        waitForExpectations(timeout: 1)
    }
}
