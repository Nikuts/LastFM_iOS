//
//  APIImage.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

// MARK: - Image
struct APIImageModel: Codable {
    let text: String?
    let size: APIImageSize?
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}
