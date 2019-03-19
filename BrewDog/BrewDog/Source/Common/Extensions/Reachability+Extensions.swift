//
//  Reachability+Extensions.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Reachability


// MARK: - BrewDogReachability
extension Reachability: BrewDogReachability {
    
    /// True if internet is reachable
    var internetIsReachable: Bool {
        return isReachable()
    }
}
