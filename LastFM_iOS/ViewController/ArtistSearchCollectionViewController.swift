//
//  ArtistSearchCollectionViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 29.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "Cell"

class ArtistSearchCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var artists = [ArtistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        createSearchBar()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for artist"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtistCollectionViewCell.self), for: indexPath) as? ArtistCollectionViewCell else {
            fatalError("Cell is not type of ArtistCollectionViewCell")
        }
        
        let artist = artists[indexPath.row]
        if let imageUrl = URL.init(string: artist.imageUrl ?? "") {
            cell.image.af_setImage(withURL: imageUrl)
        }
        
        cell.name.text = artist.name
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        os_log("Clicked.")
        guard let fetchedAlbumsVC = storyboard?.instantiateViewController(withIdentifier: String(describing: FetchedAlbumsViewController.self)) else {
            fatalError("There is no FetchedAlbumsViewController in the storyboard.")
        }
        
        fetchedAlbumsVC.navigationItem.title = artists[indexPath.row].name
        
        navigationController?.pushViewController(fetchedAlbumsVC, animated: true)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    //    MARK: UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if(!text.isEmpty){
                //reload your data source if necessary
                searchBar.resignFirstResponder()
                searchBar.setShowsCancelButton(true, animated: true)
                NetworkProvider.getArtistByName(artistName: text, page: 1) { apiArtistSearchModel in
                    
                    if let loadedArtists = apiArtistSearchModel?.results?.artistmatches?.artist {
                        self.artists = APIToBusinessModelMapper.mapArtistArray(apiArtistModelArray: loadedArtists)
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
}
