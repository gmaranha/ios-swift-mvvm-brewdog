//
//  BrewDogURLSession.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 14/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation

protocol BrewDogURLSession {
    
    /// Load data from url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completionHandler: Completion handler
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
