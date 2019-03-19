//
//  BeerListCollectionViewController.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import UIKit

class BeerListCollectionViewController: UICollectionViewController {
    struct Constants {
        static let cellsPerRow: Int = 2
        static let loadingCellHeight: CGFloat = 50
        static let insets: CGFloat = 16
        static let margins: CGFloat = CGFloat(cellsPerRow + 1) * insets
        static let marginsLoading: CGFloat = 2 * insets
        static let cellImageMargins: CGFloat = 8.0 * 2.0
        static let cellUsedHeight: CGFloat = cellImageMargins + (4.0 * 2.0) + (3.0 * 20.5)
    }
    
    private var beerListViewModel = BeerListViewModel()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .silver
        return refreshControl
    }()
}

// MARK: - Overrides
extension BeerListCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        beerListViewModel.delegate = self
        collectionView?.refreshControl = refreshControl
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BeerCollectionViewCell,
            let controller = segue.destination as? BeerDetailViewController {
            controller.setup(cell.beerViewModel)
        }
    }
}

// MARK: - Private methods
private extension BeerListCollectionViewController {
    @objc private func refresh() {
        beerListViewModel.fetch(refresh: true)
    }
}


// MARK: - Delegate
extension BeerListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .beer = beerListViewModel.cellType(at: indexPath),
            let beerCell = cell as? BeerCollectionViewCell {
            beerCell.bannerImage.kf.cancelDownloadTask()
        }
    }
}

// MARK: - Datasource
extension BeerListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beerListViewModel.numberOfItens(in: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = beerListViewModel.cellType(at: indexPath)
        switch cellType {
        case .beer(let beerViewModel):
            let cell = collectionView.dequeueReusableCell(viewType: BeerCollectionViewCell.self, for: indexPath)
            cell.setup(beer: beerViewModel)
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(viewType: BeerLoadingCollectionViewCell.self, for: indexPath)
            beerListViewModel.fetch()
            cell.setup()
            return cell
        }
    }
}


// MARK: - BeerListViewModelDelegate
extension BeerListCollectionViewController: BeerListViewModelDelegate {
    func beerListViewModelWasFetch(_ viewModel: BeerListViewModel) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func beerListViewModel(_ viewModel: BeerListViewModel, threw error: Error) {
        HandleError.handle(error: error)
    }
}

// MARK: - Flow layout
extension BeerListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellType = beerListViewModel.cellType(at: indexPath)
        switch cellType {
        case .beer:
            let width = (collectionView.frame.width - Constants.margins)/CGFloat(Constants.cellsPerRow)
            let imageSize: CGFloat = width - Constants.cellImageMargins
            let height: CGFloat = Constants.cellUsedHeight + imageSize
            return CGSize(width: width, height: height)
        case .loading:
            let width = (collectionView.frame.width - Constants.marginsLoading)
            return CGSize(width: width, height: Constants.loadingCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.insets, left: Constants.insets, bottom: Constants.insets, right: Constants.insets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.insets
    }
}
