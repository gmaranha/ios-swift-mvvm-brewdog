//
//  URLSession+Extensions.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 14/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation

// MARK: - BrewDogURLSession
extension URLSession: BrewDogURLSession {
    
    /// Data task to load
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completionHandler: completionHandler
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, urlResponse, error)
            }.resume()
    }
}
