//
//  APIStreamableModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 06.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIStreamableModel: Codable {
    let text, fulltrack: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case fulltrack
    }
}
