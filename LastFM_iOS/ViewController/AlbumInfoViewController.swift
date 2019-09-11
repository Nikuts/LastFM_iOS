//
//  AlbumDetailViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 05.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var album : AlbumModel?
    var albumInfo : AlbumInfoModel?
    
    var items = [BaseTableViewItem<Any>]()
    var trackIndex = 0
    
    let controlToolbarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initToolbarButton()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if (isSaved()) { // if saved album
            setItems()
            self.activityIndicator.stopAnimating()
            return
        }
        
        if (self.album != nil) {
            self.activityIndicator.startAnimating()
            
            NetworkProvider.getAlbumInfoByMbid(mbid: album!.mbid) { [weak self] apiAlbumInfoResultModel in
                if let apiAlbumInfoModel = apiAlbumInfoResultModel?.album {
                    self?.albumInfo = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfoModel)
                    self?.setItems()
                     self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = self.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: currentItem.cellType.rawValue, for: indexPath)
        
        if let descriptionCell = cell as? AlbumInfoDescriptionTableViewCell {
            self.initDescriptionCell(descriptionCell: descriptionCell)
        } else if let trackCell = cell as? AlbumInfoTrackTableViewCell {
            self.initTrackCell(trackCell: trackCell, track: currentItem.value as! TrackModel)
        }
        
        return cell
    }

    private func initDescriptionCell(descriptionCell: AlbumInfoDescriptionTableViewCell) {
        if let imageUrl = URL(string: self.albumInfo?.imageUrl ?? "") {
            descriptionCell.albumImage.af_setImage(withURL: imageUrl)
        }
        descriptionCell.albumDescription.text = albumInfo?.description
        descriptionCell.albumDescription.numberOfLines = 0
        descriptionCell.albumDescription.sizeToFit()
    }
    
    private func initTrackCell(trackCell: AlbumInfoTrackTableViewCell, track: TrackModel) {
        trackCell.trackName.text = "\(track.name)"
        trackCell.trackDuration.text = track.duration
    }
    
    private func isSaved() -> Bool {
        return albumInfo != nil
    }
    
    private func setItems() {
        self.items.removeAll()
        self.items.append(BaseTableViewItem(value: albumInfo, cellId: .AlbumInfoDescription))
        albumInfo?.tracks.forEach { track in
            self.items.append(BaseTableViewItem(value: track, cellId: .AlbumInfoTrack))
        }
        trackIndex = 0
        self.tableView.reloadData()
    }
    
    private func initToolbarButton() {
        updateToolbarButtonTitle()
        self.controlToolbarButton.action = #selector(saveOrDeleteAlbum(sender:))
        self.controlToolbarButton.target = self
        self.navigationItem.rightBarButtonItem = self.controlToolbarButton
    }
    
    private func updateToolbarButtonTitle() {
        if (isSaved()) {
            self.controlToolbarButton.title = "Delete"
        } else {
            self.controlToolbarButton.title = "Save"
        }
    }
    
    @objc private func saveOrDeleteAlbum(sender: UIBarButtonItem) {
        if (isSaved()) {
            if let albumInfo = self.albumInfo {
                DataBaseManager.deleteAlbumInfoByMbid(mbid: albumInfo.mbid)
                self.albumInfo = nil
            }
        } else {
            if let album = self.album {
                NetworkProvider.getAlbumInfoByMbid(mbid: album.mbid) { [weak self] apiAlbumInfoResult in
                    if let apiAlbumInfo = apiAlbumInfoResult?.album {
                        if let albumInfo = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfo) {
                            DataBaseManager.saveAlbumInfo(albumInfo: albumInfo)
                            self?.album = nil
                        }
                    }
                }
            }
        }
        updateToolbarButtonTitle()
    }
}
