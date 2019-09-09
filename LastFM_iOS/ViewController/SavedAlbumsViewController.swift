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
    
    private let cellId = String(describing: AlbumTableViewCell.self)
    private var albumInfos = [AlbumInfoModel]()
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.dataSource = self
        
        albumInfos = DataBaseManager.getAllAlbumInfos()
        self.tableView.reloadData()
    }
    
    override func registerCells() {
        let nib = UINib.init(nibName: cellId, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: self.cellId)
    }
    
    //    MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAlbumInfo(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AlbumTableViewCell else {
            fatalError("Cannot deque cell as \(AlbumTableViewCell.self)")
        }
        
        let currentAlbumInfo = self.albumInfos[indexPath.row]
        
        cell.albumActions = self
        cell.album = AlbumModel(name: currentAlbumInfo.name, imageUrl: currentAlbumInfo.imageUrl, mbid: currentAlbumInfo.mbid)
        cell.title.text = currentAlbumInfo.name
        cell.artistName.text = currentAlbumInfo.artistName
        cell.isSaved = true
        
        if let imageUrl = URL.init(string: currentAlbumInfo.imageUrl ?? "") {
            cell.albumImage.af_setImage(withURL: imageUrl)
        }
        
        return cell
    }
    
    //    MARK: Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albumInfoVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AlbumInfoViewController.self)) as? AlbumInfoViewController else {
            fatalError("There is no \(AlbumInfoViewController.self) in the storyboard.")
        }
        
        albumInfoVC.navigationItem.title = self.albumInfos[indexPath.row].name
        albumInfoVC.albumInfo = self.albumInfos[indexPath.row]
        
        navigationController?.pushViewController(albumInfoVC, animated: true)
    }
    
    // MARK: AlbumActionsProtocol

    func onDeleteAlbum(mbid: String) {
        if let index = self.albumInfos.firstIndex(where: { albumInfo in albumInfo.mbid == mbid }) {
            deleteAlbumInfo(indexPath: IndexPath(row: index, section: 0))
        }
    }
    
    //    MARK: Private methods
    
    private func deleteAlbumInfo(indexPath: IndexPath) {
        DataBaseManager.deleteAlbumInfo(albumInfo: self.albumInfos[indexPath.row])
        self.albumInfos.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
}
