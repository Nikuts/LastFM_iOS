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
    private var items = [BaseTableViewItem<AlbumModel>] ()
    
    var artist: ArtistModel?
    var currentPage = 1
    var loadingCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        if (artist != nil) {
            enableLoadingCell(enable: true)
            NetworkProvider.getTopAlbumsByMbid(mbid: self.artist!.mbid, page: self.currentPage) { [weak self] apiTopAlbumsSearchModel in
                if let loadedAlbums = apiTopAlbumsSearchModel?.topalbums?.album {
                    APIToBusinessModelMapper.mapAlbumArray(apiArtistModelArray: loadedAlbums).forEach { albumModel in
                        self?.items.append(BaseTableViewItem<AlbumModel>(value: albumModel, cellId: .Album))
                    }
                    self?.enableLoadingCell(enable: false)
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
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: currentItem.cellType.rawValue, for: indexPath)
        
        if let albumCell = cell as? AlbumTableViewCell, let currentAlbum = currentItem.value {
            
            albumCell.album = currentAlbum
            albumCell.title.text = currentAlbum.name
            albumCell.artistName.text = self.artist?.name
            albumCell.isSaved = DataBaseManager.isAlbumSavedByMbid(mbid: currentAlbum.mbid)
            albumCell.albumActions = self
            
            if let imageUrl = URL.init(string: currentAlbum.imageUrl ?? "") {
                albumCell.albumImage.af_setImage(withURL: imageUrl)
            }
        }
            
        return cell
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
        
        if let currentAlbum = items[indexPath.row].value {
            albumInfoVC.navigationItem.title = currentAlbum.name
            albumInfoVC.album = currentAlbum
        }
        
        navigationController?.pushViewController(albumInfoVC, animated: true)
    }
    
    // MARK: Private methods
    
    private func enableLoadingCell(enable: Bool) {
        if (enable && !isLoadingAdded()) {
            self.items.append(BaseTableViewItem(value: nil, cellId: .Loading))
            self.tableView.reloadData()
        } else if (!enable && isLoadingAdded()) {
            self.items.removeAll(where: {item in item.cellType == .Loading})
            self.tableView.reloadData()
        }
    }
    
    private func isLoadingAdded() -> Bool {
        return self.items.first(where: {item in item.cellType == .Loading}) != nil
    }
}
