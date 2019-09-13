//
//  AlbumTableViewCell.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 04.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var isSaved = false {
        didSet {
            if (isSaved) {
                self.saveButton.setTitle("Delete", for: .normal)
                self.saveButton.sizeToFit()
            } else {
                self.saveButton.setTitle("Save", for: .normal)
                self.saveButton.sizeToFit()
            }
        }
    }
    
    var albumActions: AlbumActionsProtocol?
    var album: AlbumModel?
    
    @IBAction func onSaveClicked(_ sender: UIButton) {
        self.isSaved = !self.isSaved
        if (isSaved) {
            if let albumMbid = album?.mbid {
                NetworkProvider.getAlbumInfoByMbid(mbid: albumMbid) { apiAlbumInfoResultModel in
                    if let apiAlbumInfoModel = apiAlbumInfoResultModel?.album {
                        if let albumInfoModel = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfoModel) {
                            albumInfoModel.artistName = self.artistName.text
                            DataBaseManager.saveAlbumInfo(albumInfo: albumInfoModel)
                        }
                    }
                }
            }
        } else {
            if let mbid = album?.mbid {
                albumActions?.onDeleteAlbum(mbid: mbid)
            }
        }
    }
}
