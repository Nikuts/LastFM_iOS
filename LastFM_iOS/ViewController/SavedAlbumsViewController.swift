//
//  SavedAlbumsTableViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 29.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit
import RealmSwift

class SavedAlbumsViewController: AlbumsViewController, UITableViewDataSource, AlbumActionsProtocol {
    
    private let albumCellId = TableCellType.Album.rawValue
    private let loadingCellId = TableCellType.Loading.rawValue
    
    private var items = [BaseTableViewItem<AlbumInfoModel>]()
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.dataSource = self
        items.removeAll()
        
        self.items.append(BaseTableViewItem(value: nil, cellId: .Loading))
        self.tableView.reloadData()
        
        self.items.append(contentsOf: DataBaseManager.getAll().map {
            BaseTableViewItem(value: $0, cellId: .Album)
        })
        
        self.items.remove(at: 0)
        self.tableView.reloadData()
    }
    
    override func registerCells() {
        let albumNib = UINib.init(nibName: albumCellId, bundle: nil)
        let loadingNib = UINib.init(nibName: loadingCellId, bundle: nil)
        
        self.tableView.register(albumNib, forCellReuseIdentifier: albumCellId)
        self.tableView.register(loadingNib, forCellReuseIdentifier: loadingCellId)
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteAlbumInfo(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (items.count == 0) {
            self.showEmptyMessage(message: "You don't have any saved albums yet.")
        } else {
            self.hideEmptyMessage()
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentItem = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: currentItem.cellType.rawValue, for: indexPath)
        
        if let currentAlbumInfo = self.items[indexPath.row].value, let albumCell = cell as? AlbumTableViewCell {
        
            albumCell.albumActions = self
            albumCell.album = AlbumModel(name: currentAlbumInfo.name, imageUrl: currentAlbumInfo.imageUrl, mbid: currentAlbumInfo.mbid)
            albumCell.title.text = currentAlbumInfo.name
            albumCell.artistName.text = currentAlbumInfo.artistName
            albumCell.isSaved = true
            
            if let imageUrl = URL.init(string: currentAlbumInfo.imageUrl ?? "") {
                albumCell.albumImage.af_setImage(withURL: imageUrl)
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let albumInfoVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AlbumInfoViewController.self)) as?
            AlbumInfoViewController else {
            fatalError("There is no \(AlbumInfoViewController.self) in the storyboard.")
        }
        
        if let currentAlbumInfo = self.items[indexPath.row].value {
            
            albumInfoVC.navigationItem.title = currentAlbumInfo.name
            albumInfoVC.albumInfo = currentAlbumInfo
        }
        
        navigationController?.pushViewController(albumInfoVC, animated: true)
    }
    
    // MARK: - AlbumActionsProtocol

    func onDeleteAlbum(mbid: String) {
        
        if let index = self.items.firstIndex(where: { item in item.value?.mbid == mbid }) {
            deleteAlbumInfo(indexPath: IndexPath(row: index, section: 0))
        }
    }
    
    //    MARK: - Private methods
    
    private func deleteAlbumInfo(indexPath: IndexPath) {
        
        if let currentAlbumInfo = self.items[indexPath.row].value {
            
            DataBaseManager.delete(albumInfo: currentAlbumInfo)
            
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
