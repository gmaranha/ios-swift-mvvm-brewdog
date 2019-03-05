//
//  BeerLoadingCollectionViewCell.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 06/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import UIKit

class BeerLoadingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}

// MARK: - Auxiliar methods
extension BeerLoadingCollectionViewCell {
    func setup() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .silver
    }
}

// MARK: - Identifiable
extension BeerLoadingCollectionViewCell: Identifiable {}
