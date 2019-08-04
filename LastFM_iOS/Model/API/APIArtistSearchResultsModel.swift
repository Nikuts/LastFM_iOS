//
//  APIArtistSearchResults.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

struct APIArtistSearchResultsModel : Codable {
    let opensearchQuery: APIOpensearchQueryModel?
    let opensearchTotalResults, opensearchStartIndex, opensearchItemsPerPage: String?
    let artistmatches: APIArtistMatchesModel?
    let attr: APIArtistSearchAttrModel?
    
    enum CodingKeys: String, CodingKey {
        case opensearchQuery = "opensearch:Query"
        case opensearchTotalResults = "opensearch:totalResults"
        case opensearchStartIndex = "opensearch:startIndex"
        case opensearchItemsPerPage = "opensearch:itemsPerPage"
        case artistmatches
        case attr = "@attr"
    }
}
