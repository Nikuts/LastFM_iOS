//
//  AlbumInfoModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 06.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

class AlbumInfoModel {
    
    let name: String
    let imageUrl: String?
    let mbid: String
    let tracks: [TrackModel]
    
    init(name: String, imageUrl: String?, mbid: String, tracks: [TrackModel]) {
        self.name = name
        self.imageUrl = imageUrl
        self.mbid = mbid
        self.tracks = tracks
    }
}
