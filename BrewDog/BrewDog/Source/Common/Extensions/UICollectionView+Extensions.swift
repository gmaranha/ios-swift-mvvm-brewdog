//
//  UICollectionView+Extensions.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 06/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    /// Dequeues identifiable cell
    ///
    /// - Parameters:
    ///   - viewType: Cell class type
    ///   - indexPath: indexPath
    /// - Returns: Typed cell
    func dequeueReusableCell<T>(viewType: T.Type, for indexPath: IndexPath) -> T where T: Identifiable & UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Invalid cell type: \(String(describing: T.self))")
        }
        return cell
    }
}
