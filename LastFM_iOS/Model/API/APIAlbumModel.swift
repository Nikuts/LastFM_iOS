//
//  APIAlbumModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 03.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIAlbumModel: Codable {
    let name: String?
    let playcount: Int?
    let mbid: String?
    let url: String?
    let artist: APIAlbumArtistModel?
    let image: [APIImageModel]?
}
