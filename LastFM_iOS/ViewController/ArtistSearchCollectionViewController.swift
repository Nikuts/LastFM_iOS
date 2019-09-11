//
//  ArtistSearchCollectionViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 29.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit
import os.log

class ArtistSearchCollectionViewController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    private var items = [BaseCollectionViewItem<ArtistModel>]()
    
    private let defaultSize = CGSize(width: 130, height: 180)
    
    private let numberOfSections = 1
    
    private var currentPage = 1
    
    private var loadingItemIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        createSearchBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.prefetchDataSource = self
        
        self.collectionView.register(UINib(nibName: CollectionCellType.Loading.rawValue, bundle: nil), forCellWithReuseIdentifier: CollectionCellType.Loading.rawValue)
    }
    
    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for artist"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }

    //    MARK: UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let lastIndex = indexPaths.last?.row {
            if (!items.isEmpty && lastIndex <= items.count - 10) {
                os_log("Prefetching time!")
                
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentItem = self.items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentItem.cellType.rawValue, for: indexPath)
        
        if let artistCell = cell as? ArtistCollectionViewCell {
            if let imageUrl = URL.init(string: currentItem.value?.imageUrl ?? "") {
                artistCell.image.af_setImage(withURL: imageUrl)
            }
            
            artistCell.name.text = currentItem.value?.name
        }
        
        if let loadingCell = cell as? LoadingCollectionViewCell {
            loadingCell.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (items[indexPath.row].cellType == .Loading) {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 40)
        } else {
            return defaultSize
        }
    }
    
    // MARK: UICollectionViewDelegate & Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let fetchedAlbumsVC = storyboard?.instantiateViewController(withIdentifier: String(describing: FetchedAlbumsViewController.self)) as? FetchedAlbumsViewController else {
            fatalError("There is no FetchedAlbumsViewController in the storyboard.")
        }
        if let currentArtist = items[indexPath.row].value {
            fetchedAlbumsVC.navigationItem.title = currentArtist.name
            fetchedAlbumsVC.artist = currentArtist
        }
        
        navigationController?.pushViewController(fetchedAlbumsVC, animated: true)
    }
    
    //    MARK: UISearchBarDelegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if(!text.isEmpty){
                
                self.items.removeAll()
                self.collectionView?.reloadData()
                
                enableLoadingCell(enable: true)
                
                searchBar.resignFirstResponder()
                searchBar.setShowsCancelButton(true, animated: true)
                
                fetchArtists(name: text, page: self.currentPage)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    //    MARK: Networking
    
    private func fetchArtists(name: String, page: Int) {
    
        NetworkProvider.getArtistByName(artistName: name, page: page) { [weak self] apiArtistSearchModel in
            
            if let loadedArtists = apiArtistSearchModel?.results?.artistmatches?.artist {
                APIToBusinessModelMapper.mapArtistArray(apiArtistModelArray: loadedArtists).forEach { artistModel in
                    self?.items.append(BaseCollectionViewItem<ArtistModel>(value: artistModel, cellId: .Artist))
                }
                self?.enableLoadingCell(enable: false)
            }
        }
    }
    
    private func enableLoadingCell(enable: Bool) {
        if (enable && !isLoadingAdded()) {
            self.items.append(BaseCollectionViewItem(value: nil, cellId: .Loading))
            self.collectionView.reloadData()
        } else if (!enable && isLoadingAdded()) {
            self.items.removeAll(where: {item in item.cellType == .Loading})
            self.collectionView.reloadData()
        }
    }
    
    private func isLoadingAdded() -> Bool {
        return self.items.first(where: {item in item.cellType == .Loading}) != nil
    }
}
