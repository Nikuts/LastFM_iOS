//
//  AlbumModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 03.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

class AlbumModel {
    
    let name: String
    let imageUrl: String?
    let mbid: String
    
    init(name: String, imageUrl: String?, mbid: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.mbid = mbid
    }
}
