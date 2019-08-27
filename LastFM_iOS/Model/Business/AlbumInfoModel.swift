//
//  AlbumInfoModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 06.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

class AlbumInfoModel {
    var artistName: String?
    let name: String
    let imageUrl: String?
    let mbid: String
    let description: String?
    let tracks: [TrackModel]
    
    init(artistName: String?, name: String, imageUrl: String?, mbid: String, description: String?, tracks: [TrackModel]) {
        self.artistName = artistName
        self.name = name
        self.imageUrl = imageUrl
        self.mbid = mbid
        self.description = description
        self.tracks = tracks
    }
}
