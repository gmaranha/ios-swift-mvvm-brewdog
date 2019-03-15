//
//  BrewDogReachability.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation

protocol BrewDogReachability {
    
    /// True if internet is available
    var internetIsReachable: Bool { get }
}
