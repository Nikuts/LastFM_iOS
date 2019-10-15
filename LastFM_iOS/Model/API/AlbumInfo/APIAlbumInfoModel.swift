//
//  APIAlbumInfoModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 06.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIAlbumInfoModel: Codable {
    let name: String?
    let artist: String?
    let mbid: String?
    let url: String?
    let image: [APIImageModel]?
    let listeners: String?
    let playcount: String?
    let tracks: APITracksModel?
    let tags: APITagsModel?
    let wiki: APIWikiModel?
}
