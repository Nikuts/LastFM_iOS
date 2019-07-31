//
//  APIOpenSearchQuery.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIOpensearchQueryModel: Codable {
    let text, role, searchTerms, startPage: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role, searchTerms, startPage
    }
}
