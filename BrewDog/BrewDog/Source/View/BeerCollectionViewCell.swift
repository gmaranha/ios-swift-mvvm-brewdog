//
//  BeerTableViewCell.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alcoholByVolumeLabel: UILabel!
    
    private(set) var beerViewModel: BeerViewModel!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        layer.cornerRadius = 4
        layer.masksToBounds = false
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImage.kf.cancelDownloadTask()
    }
}

// MARK: - Auxiliar methods
extension BeerCollectionViewCell {
    func setup(beer: BeerViewModel) {
        beerViewModel = beer
        nameLabel.text = beer.name
        alcoholByVolumeLabel.text = beer.abvString
        bannerImage.setImage(with: beer.imageURL)
    }
}

// MARK: - Identifiable
extension BeerCollectionViewCell: Identifiable {}
