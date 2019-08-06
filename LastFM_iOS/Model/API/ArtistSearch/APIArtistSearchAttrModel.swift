//
//  APIAttr.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIArtistSearchAttrModel: Codable {
    let attrFor: String?
    
    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
    }
}
