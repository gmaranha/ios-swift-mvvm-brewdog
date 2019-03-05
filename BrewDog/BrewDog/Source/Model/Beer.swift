//
//  Beer.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation

struct Beer: Decodable {
    var id: Int?
    var imageURL: String?
    var name: String?
    var tagline: String?
    var alcoholByVolume: Double?
    var internationalBitternessUnits: Double?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
        case tagline
        case alcoholByVolume = "abv"
        case internationalBitternessUnits = "ibu"
        case description
    }
}
