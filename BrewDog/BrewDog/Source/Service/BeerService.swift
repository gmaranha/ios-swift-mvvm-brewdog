//
//  BeerService.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation
import Reachability


/// Beer service
protocol BeerServiceProtocol {
    
    /// Gets beer list
    ///
    /// - Parameters:
    ///   - page: Page number (starting in 1)
    ///   - perPage: Items per page (max = 80)
    ///   - completion: Completion block
    func getBeerList(page: Int, perPage: Int, completion: @escaping ((() throws -> (BeerList)) -> Void))
}

class BeerService: BeerServiceProtocol {
    private struct Constants {
        static let beerListUrl = "https://api.punkapi.com/v2/beers"
        static let queryPage = "page"
        static let queryPerPage = "per_page"
    }
    
    private let session: BrewDogURLSession
    private let reachability: BrewDogReachability
    
    init(session: BrewDogURLSession = URLSession.shared, reachability: BrewDogReachability = Reachability(hostName: Constants.beerListUrl)) {
        self.session = session
        self.reachability = reachability
    }
    
    func getBeerList(page: Int, perPage: Int, completion: @escaping ((() throws -> (BeerList)) -> Void)) {
        guard reachability.internetIsReachable else {
            completion { throw BrewDogError.offlineMode }
            return
        }
        
        guard let url = beerListUrl(page: page, perPage: perPage) else {
            completion { throw BrewDogError.generic }
            return
        }

        session.loadData(from: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    
                    let beerList = BeerList(beers: beers)
                    
                    completion { beerList }
                } catch {
                    completion { throw BrewDogError.parse(String(describing: [Beer].self)) }
                }
            }
        }
    }
}

// MARK: - Private methods
private extension BeerService {
    func beerListUrl(page: Int, perPage: Int) -> URL? {
        var urlComponents = URLComponents(string: Constants.beerListUrl)
        urlComponents?.queryItems = [URLQueryItem(name: Constants.queryPage, value: "\(page)"),
                                     URLQueryItem(name: Constants.queryPerPage, value: "\(perPage)")]
        
        return urlComponents?.url
    }
}
