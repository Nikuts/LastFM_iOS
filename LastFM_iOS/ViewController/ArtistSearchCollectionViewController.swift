//
//  ArtistSearchCollectionViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 29.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit
import os.log

class ArtistSearchCollectionViewController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDataSourcePrefetching {
    
    var artists = [ArtistModel]()
    
    private let artistCellReuseIdentifier = String(describing: ArtistCollectionViewCell.self)
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.prefetchDataSource = self
        
        createSearchBar()
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
            if (!artists.isEmpty && lastIndex <= artists.count - 10) {
                os_log("Prefetching time!")
                
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: artistCellReuseIdentifier, for: indexPath) as? ArtistCollectionViewCell else {
            fatalError("Cell is not type of ArtistCollectionViewCell")
        }
        
        let artist = artists[indexPath.row]
        if let imageUrl = URL.init(string: artist.imageUrl ?? "") {
            cell.image.af_setImage(withURL: imageUrl)
        }
        
        cell.name.text = artist.name
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate & Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let fetchedAlbumsVC = storyboard?.instantiateViewController(withIdentifier: String(describing: FetchedAlbumsViewController.self)) as? FetchedAlbumsViewController else {
            fatalError("There is no FetchedAlbumsViewController in the storyboard.")
        }
        
        fetchedAlbumsVC.navigationItem.title = artists[indexPath.row].name
        fetchedAlbumsVC.artist = artists[indexPath.row]
        
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
                
                self.artists.removeAll()
                self.collectionView?.reloadData()
                
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
                self?.artists = APIToBusinessModelMapper.mapArtistArray(apiArtistModelArray: loadedArtists)
                self?.collectionView?.reloadData()
            }
        }
    }
}
