//
//  Errors.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation


/// Possible errors
///
/// - httpError: Http response error
/// - generic: Unknown error
/// - parse: parse error
/// - offlineMode: user is offline
enum BrewDogError: Error {
    case httpError(Int)
    case generic
    case parse(String)
    case offlineMode
}
