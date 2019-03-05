//
//  UIImageView+Extensions.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 07/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    /// Set default placeholder 
    func setImagePlaceHolder() {
        let placeholder = UIImage(named: "image-placeholder")
        self.image = placeholder
        self.contentMode = .center
    }
    
    
    /// Downloads images using kingfisher
    ///
    /// - Parameter stringURL: URL
    func setImage(with stringURL: String) {
        self.setImagePlaceHolder()
        
        let url = URL(string: stringURL)
        
        self.kf.setImage(with: url,
                         placeholder: self.image) { result in
                            if case .success = result {
                                self.contentMode = .scaleAspectFit
                            }
        }
    }
}
