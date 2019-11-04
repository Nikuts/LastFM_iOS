//
//  AlbumDetailViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 05.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumInfoViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var album: AlbumModel?
    var albumInfo: AlbumInfoModel?
    
    var items = [BaseTableViewItem<Any>]()
    var trackIndex = 0
    var isSaved = false
    
    private let controlToolbarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSaved = self.albumInfo != nil
        self.initToolbarButton()
        
        if (self.isSaved) { // if saved album
            
            self.setItems()
            self.disableLoadingIndicator()
            
            return
        }
        
        if (self.album != nil) {
            
            self.enableLoadingIndicator()
            
            NetworkProvider.getAlbumInfo(mbid: album!.mbid) { [weak self] apiAlbumInfoResultModel in
                if let apiAlbumInfoModel = apiAlbumInfoResultModel?.album {
                    
                    self?.albumInfo = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfoModel)
                    self?.setItems()
                    self?.disableLoadingIndicator()
                    
                }
            }
        }
    }
    
    private func setItems() {
            self.items.removeAll()
            
            self.items.append(BaseTableViewItem(value: albumInfo, cellId: .AlbumInfoDescription))
            
//            TODO: howto?
//            if let unwrappedTracks = albumInfo?.tracks {
//                let newItems = unwrappedTracks.map { BaseTableViewItem(value: $0, cellId: .AlbumInfoTrack) }
//                self.items.append(contentsOf: newItems)
//            }

            albumInfo?.tracks.forEach { track in
                self.items.append(BaseTableViewItem(value: track, cellId: .AlbumInfoTrack))
            }
            
            trackIndex = 0
            
            self.tableView.reloadData()
        }

    // MARK: - Empty message
    
    internal func enableLoadingIndicator() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .none
        self.activityIndicator.startAnimating()
      }
      
    internal func disableLoadingIndicator() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - Toolbar
    
    private func initToolbarButton() {
        updateToolbarButtonTitle()
        
        self.controlToolbarButton.action = #selector(saveOrDeleteAlbum(sender:))
        self.controlToolbarButton.target = self
        
        self.navigationItem.rightBarButtonItem = self.controlToolbarButton
    }
    
    private func updateToolbarButtonTitle() {
        if (self.isSaved) {
            self.controlToolbarButton.title = "Delete"
        } else {
            self.controlToolbarButton.title = "Save"
        }
    }
    
    @objc private func saveOrDeleteAlbum(sender: UIBarButtonItem) {
        if (self.isSaved) {
            
            if let albumInfo = self.albumInfo {
                
                DataBaseManager.delete(mbid: albumInfo.mbid)
                
                self.isSaved = false
                
                updateToolbarButtonTitle()
            }
        } else {
            
            if let mbid = Array(arrayLiteral: self.album?.mbid, self.albumInfo?.mbid).first(where: {$0 != nil}) {
            
                if let unwrappedMbid = mbid {
                    
                    NetworkProvider.getAlbumInfo(mbid: unwrappedMbid) { [weak self] apiAlbumInfoResult in
                        
                        if let apiAlbumInfo = apiAlbumInfoResult?.album {
                            
                            if let albumInfo = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfo) {
                                
                                DataBaseManager.save(albumInfo: albumInfo)
                                
                                self?.album = nil
                                self?.isSaved = true
                                
                                self?.updateToolbarButtonTitle()
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension AlbumInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = self.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: currentItem.cellType.rawValue, for: indexPath)
        
        if let descriptionCell = cell as? AlbumInfoDescriptionTableViewCell {
            self.configureDescriptionCell(descriptionCell: descriptionCell)
        } else if let trackCell = cell as? AlbumInfoTrackTableViewCell {
            self.configureTrackCell(trackCell: trackCell, track: currentItem.value as! TrackModel)
        }
        
        return cell
    }
    
    // MARK: - Cells configuration
       
    private func configureDescriptionCell(descriptionCell: AlbumInfoDescriptionTableViewCell) {
        if let imageUrl = URL(string: self.albumInfo?.imageUrl ?? "") {
            descriptionCell.albumImage.af_setImage(withURL: imageUrl)
        }
        descriptionCell.albumDescription.text = albumInfo?.description
        descriptionCell.albumDescription.numberOfLines = 0
        descriptionCell.albumDescription.sizeToFit()
    }
   
    private func configureTrackCell(trackCell: AlbumInfoTrackTableViewCell, track: TrackModel) {
        trackCell.trackName.text = "\(track.name)"
        trackCell.trackDuration.text = track.duration
    }
}
