//
//  ReachabilityMock.swift
//  BrewDogTests
//
//  Created by Giuliano Maranha on 15/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

@testable import BrewDog

class ReachabilityMock: BrewDogReachability {
    private var reachable: Bool
    
    init(reachable: Bool = true) {
        self.reachable = reachable
    }
    
    var internetIsReachable: Bool {
        return reachable
    }
}
