//
//  FetchedAlbumsViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 02.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class FetchedAlbumsViewController: AlbumsViewController, UITableViewDataSource, AlbumActionsProtocol {

    private let albumCellId = String(describing: AlbumTableViewCell.self)
    private let loadingCellId = String(describing: LoadingTableViewCell.self)
    private var albums = [AlbumModel] ()
    
    var artist: ArtistModel?
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        if (artist != nil) {
            NetworkProvider.getTopAlbumsByMbid(mbid: self.artist!.mbid, page: self.currentPage) { [weak self] apiTopAlbumsSearchModel in
                if let loadedAlbums = apiTopAlbumsSearchModel?.topalbums?.album {
                    self?.albums = APIToBusinessModelMapper.mapAlbumArray(apiArtistModelArray: loadedAlbums)
                    self?.tableView?.reloadData()
                }
            }
        }
    }
    
    override func registerCells() {
        let albumNib = UINib.init(nibName: albumCellId, bundle: nil)
        let loadingNib = UINib.init(nibName: loadingCellId, bundle: nil)
        
        self.tableView.register(albumNib, forCellReuseIdentifier: albumCellId)
        self.tableView.register(loadingNib, forCellReuseIdentifier: loadingCellId)
    }
    
    //    MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < albums.count) {
            guard let albumCell = tableView.dequeueReusableCell(withIdentifier: albumCellId, for: indexPath) as? AlbumTableViewCell else {
                fatalError("Cannot deque cell as \(AlbumTableViewCell.self)")
            }
            
            let currentAlbum = self.albums[indexPath.row]
            
            albumCell.album = currentAlbum
            albumCell.title.text = currentAlbum.name
            albumCell.artistName.text = self.artist?.name
            albumCell.isSaved = DataBaseManager.isAlbumSavedByMbid(mbid: currentAlbum.mbid)
            albumCell.albumActions = self
            
            if let imageUrl = URL.init(string: currentAlbum.imageUrl ?? "") {
                albumCell.albumImage.af_setImage(withURL: imageUrl)
            }
            
            return albumCell
        } else {
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: loadingCellId, for: indexPath) as? LoadingTableViewCell else {
                fatalError("Cannot deque cell as \(LoadingTableViewCell.self)")
            }
            return loadingCell
        }
    }
    
    //    MARK: AlbumActionsProtocol
    
    func onDeleteAlbum(mbid: String) {
        DataBaseManager.deleteAlbumInfoByMbid(mbid: mbid)
    }
    
    //    MARK: Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albumInfoVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AlbumInfoViewController.self)) as? AlbumInfoViewController else {
            fatalError("There is no \(AlbumInfoViewController.self) in the storyboard.")
        }
        
        albumInfoVC.navigationItem.title = self.albums[indexPath.row].name
        albumInfoVC.album = self.albums[indexPath.row]
        
        navigationController?.pushViewController(albumInfoVC, animated: true)
    }
}
