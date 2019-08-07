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
    
    var album : AlbumModel?
    var albumInfo : AlbumInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.album != nil) {
            NetworkProvider.getAlbumInfoByMbid(mbid: album!.mbid) { [unowned self] apiAlbumInfoResultModel in
                if let apiAlbumInfoModel = apiAlbumInfoResultModel?.album {
                    self.albumInfo = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfoModel)
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (albumInfo?.tracks.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            return createDescriptionCell(indexPath: indexPath)
        } else {
            return createTrackCell(indexPath: indexPath, trackIndex: indexPath.row - 1)
        }
    }

    private func createDescriptionCell(indexPath: IndexPath) -> UITableViewCell {
        guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlbumInfoDescriptionTableViewCell.self), for: indexPath) as? AlbumInfoDescriptionTableViewCell else {
            fatalError("Can't deque cell with type \(AlbumInfoDescriptionTableViewCell.self)")
        }
        
        if let imageUrl = URL(string: self.albumInfo?.imageUrl ?? "") {
            descriptionCell.albumImage.af_setImage(withURL: imageUrl)
        }
        descriptionCell.albumDescription.text = albumInfo?.description
        descriptionCell.albumDescription.numberOfLines = 0
        descriptionCell.albumDescription.sizeToFit()
        
        return descriptionCell
    }
    
    private func createTrackCell(indexPath: IndexPath, trackIndex: Int) -> UITableViewCell {
        guard let trackCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlbumInfoTrackTableViewCell.self), for: indexPath) as? AlbumInfoTrackTableViewCell else {
            fatalError("Can't deque cell with type \(AlbumInfoTrackTableViewCell.self)")
        }
        trackCell.trackName.text = "\(trackIndex + 1) \(albumInfo?.tracks[trackIndex].name ?? "")"
        trackCell.trackDuration.text = albumInfo?.tracks[trackIndex].duration
        
        return trackCell
    }

}
