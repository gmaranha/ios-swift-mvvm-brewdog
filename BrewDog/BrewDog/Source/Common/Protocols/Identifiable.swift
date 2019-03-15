//
//  Identifiable.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation
import UIKit


protocol Identifiable: class {
}

// MARK: - Identifiable Extension on UIView
extension Identifiable where Self: UIView {
    
    /// Reuse identifier used in storyboards
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
