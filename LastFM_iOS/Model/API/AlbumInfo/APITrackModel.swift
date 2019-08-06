//
//  APITrackModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 06.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APITrackModel: Codable {
    let name: String?
    let url: String?
    let duration: String?
    let attr: APIAlbumInfoAttrModel?
    let streamable: APIStreamableModel?
    let artist: APIAlbumArtistModel?
    
    enum CodingKeys: String, CodingKey {
        case name, url, duration
        case attr = "@attr"
        case streamable, artist
    }
}
