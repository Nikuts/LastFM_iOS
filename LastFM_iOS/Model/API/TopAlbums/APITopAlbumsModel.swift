//
//  APITopAlbumsModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 03.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APITopAlbumsModel: Codable {
    let album: [APIAlbumModel]?
    let attr: APITopAlbumsAttrModel?
    
    enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}
