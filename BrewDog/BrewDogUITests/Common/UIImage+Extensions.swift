//
//  UIImage+Extensions.swift
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 26/04/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation
import UIKit
import XCTest

extension UIImage {
    func removing(statusBar: XCUIElement) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        
        let yOffset = Int(statusBar.frame.height * scale)
        let rect = CGRect(
            x: Int(),
            y: yOffset,
            width: cgImage.width,
            height: cgImage.height - yOffset
        )
        
        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }
        
        return nil
    }
}
