//
//  APITopAlbumsAttrModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 03.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APITopAlbumsAttrModel: Codable {
    let artist: String?
    let page, perPage, totalPages, total: String?
}
