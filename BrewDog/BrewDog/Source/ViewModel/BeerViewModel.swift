//
//  BeerViewModel.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

struct BeerViewModel {
    private(set) var id: Int = Int()
    private(set) var imageURL: String = String()
    private(set) var name: String = String()
    private(set) var tagline: String = String()
    private(set) var alcoholByVolume: Double = Double()
    private(set) var internationalBitternessUnits: Double = Double()
    private(set) var description: String = String()
    
    var abvString: String {
        return "abv \(String(format: "%.1f", alcoholByVolume))%"
    }
    
    var ibuString: String {
        return "ibu \(String(format: "%.1f", internationalBitternessUnits))"
    }
}

extension BeerViewModel {
    init(_ beer: Beer) {
        id = beer.id ?? Int()
        imageURL = beer.imageURL ?? String()
        name = beer.name ?? String()
        tagline = beer.tagline ?? String()
        alcoholByVolume = beer.alcoholByVolume ?? Double()
        internationalBitternessUnits = beer.internationalBitternessUnits ?? Double()
        description = beer.description ?? String()
    }
}
