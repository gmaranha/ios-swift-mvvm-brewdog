//
//  BeerDetailViewController.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 06/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import UIKit

class BeerDetailViewController: UIViewController {
    @IBOutlet weak var bannerImageView: UIImageView! {
        didSet {
            bannerImageView.setImage(with: beerViewModel.imageURL)
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = beerViewModel.name
        }
    }
    @IBOutlet weak var taglineLabel: UILabel! {
        didSet {
            taglineLabel.text = beerViewModel.tagline
        }
    }
    @IBOutlet weak var alcoholByVolumeLabel: UILabel! {
        didSet {
            alcoholByVolumeLabel.text = beerViewModel.abvString
        }
    }
    @IBOutlet weak var internationalBitternessUnitsLabel: UILabel! {
        didSet {
            internationalBitternessUnitsLabel.text = beerViewModel.ibuString
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = beerViewModel.description
        }
    }
    
    private var beerViewModel: BeerViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        bannerImageView.kf.cancelDownloadTask()
    }
}

// MARK: - Auxiliar methods
extension BeerDetailViewController {
    func setup(_ viewModel: BeerViewModel) {
        beerViewModel = viewModel
    }
}
