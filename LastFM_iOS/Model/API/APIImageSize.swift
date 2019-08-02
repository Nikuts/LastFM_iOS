//
//  APIImageSize.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

enum APIImageSize: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case mega = "mega"
    case small = "small"
    
    static func indexOf(apiImageSize: APIImageSize) -> Int {
        return [small, medium, large, extralarge, mega].firstIndex(of: apiImageSize)!
    }
}
