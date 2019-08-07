//
//  FetchedAlbumsViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 02.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class FetchedAlbumsViewController: AlbumsViewController {

    private let cellId = String(describing: AlbumTableViewCell.self)
    
    var artist: ArtistModel?
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (artist != nil) {
            NetworkProvider.getTopAlbumsByMbid(mbid: self.artist!.mbid, page: self.currentPage) { [unowned self] apiTopAlbumsSearchModel in
                if let loadedAlbums = apiTopAlbumsSearchModel?.topalbums?.album {
                    self.albums = APIToBusinessModelMapper.mapAlbumArray(apiArtistModelArray: loadedAlbums)
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    override func registerCells() {
        let nib = UINib.init(nibName: cellId, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //    MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AlbumTableViewCell else {
            fatalError("Cannot deque cell as \(AlbumTableViewCell.self)")
        }
        
        cell.title.text = albums[indexPath.row].name
        if let imageUrl = URL.init(string: albums[indexPath.row].imageUrl ?? "") {
            cell.albumImage.af_setImage(withURL: imageUrl)
        }
        
        return cell
    }
    
    //    MARK: Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albumInfoVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AlbumInfoViewController.self)) as? AlbumInfoViewController else {
            fatalError("There is no \(AlbumInfoViewController.self) in the storyboard.")
        }
        
        albumInfoVC.navigationItem.title = albums[indexPath.row].name
        albumInfoVC.album = albums[indexPath.row]
        
        navigationController?.pushViewController(albumInfoVC, animated: true)
    }
}
