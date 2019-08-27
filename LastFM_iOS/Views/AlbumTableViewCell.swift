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
    
    var album: AlbumModel?
    
    @IBAction func onSaveClicked(_ sender: UIButton) {
        if let albumMbid = album?.mbid {
            NetworkProvider.getAlbumInfoByMbid(mbid: albumMbid) { apiAlbumInfoResultModel in
                if let apiAlbumInfoModel = apiAlbumInfoResultModel?.album {
                    if let albumInfoModel = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfoModel) {
                        albumInfoModel.artistName = self.artistName.text
                        DataBaseManager.saveAlbumInfoModel(albumInfo: albumInfoModel)
                    }
                }
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
