//
//  BeerListViewModel.swift
//  BrewDog
//
//  Created by Giuliano Maranha on 05/03/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

import Foundation

/// Delegate to comunicate with controller
protocol BeerListViewModelDelegate: class {
    
    /// Called when the list of beer is updated
    ///
    /// - Parameter viewModel: BeerListViewModel
    func beerListViewModelWasFetch(_ viewModel: BeerListViewModel)
    
    
    /// Called when some error happen
    ///
    /// - Parameters:
    ///   - viewModel: BeerListViewModel
    ///   - error: Error
    func beerListViewModel(_ viewModel: BeerListViewModel, threw error: Error)
}

class BeerListViewModel {
    weak var delegate: BeerListViewModelDelegate?
    
    private(set) var beers: [BeerViewModel] = []
    
    private var page: Int = 0
    private var service: BeerServiceProtocol
    private var fetchCompleted = false
    private var isFetching = false
    private var error = false
    
    init(beerService: BeerServiceProtocol = BeerService()) {
        self.service = beerService
    }
}

// MARK: - Private
private extension BeerListViewModel {
    struct Constants {
        static let pageSize: Int = 8
    }
    
    func refresh() {
        page = 0
        fetchCompleted = false
    }
}

// MARK: - Auxiliar methods
extension BeerListViewModel {
    
    /// Possible cell types
    ///
    /// - beer: beer cell
    /// - loading: loading cell
    enum CellType {
        case beer(BeerViewModel)
        case loading
    }
    
    
    /// Number of items in section
    ///
    /// - Parameter section: section
    /// - Returns: number of itens
    func numberOfItens(in section: Int) -> Int {
        let addLoadingCell = fetchCompleted || error ? 0 : 1
        return beers.count + addLoadingCell
    }
    
    
    /// Cell type at index path
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: Cell type
    func cellType(at indexPath: IndexPath) -> CellType {
        if indexPath.row > beers.count - 1 {
            return .loading
        }
        return .beer(beers[indexPath.row])
    }
    
    
    /// Fetches beer list
    ///
    /// - Parameter refresh: True if screen is being refreshed
    func fetch(refresh: Bool = false) {
        guard (!fetchCompleted && !isFetching) || !isFetching else {
            return
        }
        
        if refresh {
            self.refresh()
        }
        
        error = false
        page += 1
        isFetching = true
        service.getBeerList(page: page, perPage: Constants.pageSize) { [weak self] (callback) in
            guard let weakSelf = self else { return }
            do {
                
                let beerList = try callback()
                
                if refresh {
                    weakSelf.beers = []
                }
                if beerList.beers.isEmpty {
                    weakSelf.fetchCompleted = true
                } else {
                    weakSelf.beers.append(contentsOf: beerList.beers.map({ (beer) -> BeerViewModel in
                        BeerViewModel(beer)
                    }))
                }
                
                weakSelf.delegate?.beerListViewModelWasFetch(weakSelf)
            } catch {
                weakSelf.delegate?.beerListViewModel(weakSelf, threw: error)
                weakSelf.error = true
                weakSelf.page -= 1
                weakSelf.delegate?.beerListViewModelWasFetch(weakSelf)
            }
            weakSelf.isFetching = false
        }
    }
}
