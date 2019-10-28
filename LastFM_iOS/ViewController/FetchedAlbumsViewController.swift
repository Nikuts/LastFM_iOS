//
//  FetchedAlbumsViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 02.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class FetchedAlbumsViewController: AlbumsViewController, UITableViewDataSource, AlbumActionsProtocol, UITableViewDataSourcePrefetching {

    private let albumCellId = String(describing: AlbumTableViewCell.self)
    private let loadingCellId = String(describing: LoadingTableViewCell.self)
    private var items = [BaseTableViewItem<AlbumModel>] ()
    
    var artist: ArtistModel?
    var currentPage = 1
    var maxPages = 1
    var loadingCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        
        items.removeAll()
        
        loadAlbums()
    }
    
    override func registerCells() {
        let albumNib = UINib.init(nibName: albumCellId, bundle: nil)
        let loadingNib = UINib.init(nibName: loadingCellId, bundle: nil)
        
        self.tableView.register(albumNib, forCellReuseIdentifier: albumCellId)
        self.tableView.register(loadingNib, forCellReuseIdentifier: loadingCellId)
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (items.count == 0) {
            self.showEmptyMessage(message: nil)
        } else {
            self.hideEmptyMessage()
        }
        
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: currentItem.cellType.rawValue, for: indexPath)
        
        if let albumCell = cell as? AlbumTableViewCell, let currentAlbum = currentItem.value {
            
            albumCell.album = currentAlbum
            albumCell.title.text = currentAlbum.name
            albumCell.artistName.text = self.artist?.name
            albumCell.isSaved = DataBaseManager.isSaved(mbid: currentAlbum.mbid)
            albumCell.albumActions = self
            
            if let imageUrl = URL.init(string: currentAlbum.imageUrl ?? "") {
                albumCell.albumImage.af_setImage(withURL: imageUrl)
            }
        }
            
        return cell
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastIndex = indexPaths.last?.row {
            
            if (!items.isEmpty && lastIndex >= items.count - 5 && !isLoadingAdded() && currentPage < maxPages) {
                print("Prefetching time")
                
                self.currentPage += 1
                
                loadAlbums()
            }
        }
    }
    
    //    MARK: - AlbumActionsProtocol
    
    func onDeleteAlbum(mbid: String) {
        DataBaseManager.delete(mbid: mbid)
    }
    
    //    MARK: - UITableViewDelegate
    
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
    
    // MARK: - Private methods
    
    private func enableLoadingCell(enable: Bool) {
        if (enable && !isLoadingAdded()) {
            
            self.tableView.beginUpdates()
            
            self.items.append(BaseTableViewItem(value: nil, cellId: .Loading))
            self.tableView.insertRows(at: [IndexPath(row: self.items.count - 1, section: 0)], with: .none)
            
            self.tableView.endUpdates()
            
        } else if (!enable && isLoadingAdded()) {
            
            if let loadingIndex = self.items.firstIndex(where: {item in item.cellType == .Loading}) {
                
                self.tableView.beginUpdates()
                
                self.items.remove(at: loadingIndex)
                self.tableView.deleteRows(at: [IndexPath(row: loadingIndex, section: 0)], with: .none)
                
                self.tableView.endUpdates()
            }
            
        }
    }
    
    private func isLoadingAdded() -> Bool {
        return self.items.first(where: {item in item.cellType == .Loading}) != nil
    }
    
    private func loadAlbums() {
        if (artist != nil) {
            enableLoadingCell(enable: true)
            
            NetworkProvider.getTopAlbums(mbid: self.artist!.mbid, page: self.currentPage) { [weak self] apiTopAlbumsSearchModel in
                if let totalPages = Int(apiTopAlbumsSearchModel?.topalbums?.attr?.totalPages ?? "") {
                    
                    self?.maxPages = totalPages
                }
                if let loadedAlbums = apiTopAlbumsSearchModel?.topalbums?.album {
                    
                    self?.onAlbumsLoaded(albums: APIToBusinessModelMapper.mapAlbumArray(apiArtistModelArray: loadedAlbums))
                    self?.enableLoadingCell(enable: false)
                    
                }
            }
        }
    }
    
    private func onAlbumsLoaded(albums: [AlbumModel]) {
        
        let startRow = items.count - 1
        let endRow = startRow + albums.count
        
        self.items.append(contentsOf: albums.map {
            BaseTableViewItem(value: $0, cellId: .Album)
        })
        
        let indexPathsToInsert = (startRow..<endRow).map { IndexPath(row: $0, section: 0) }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
        self.tableView.endUpdates()
    }
}
