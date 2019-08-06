
//
//  APIArtist.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIArtistModel: Codable {
    let name, listeners, mbid: String?
    let url: String?
    let streamable: String?
    let image: [APIImageModel]?
}
