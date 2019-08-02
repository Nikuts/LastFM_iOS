//
//  APIToBusinessModelMapper.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 02.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

class APIToBusinessModelMapper {
    static func mapArtistArray(apiArtistModelArray: [APIArtistModel]) -> [ArtistModel] {
        var artistModelArray = [ArtistModel]()
        apiArtistModelArray.forEach { apiArtistModel in
            if let artistName = apiArtistModel.name {
                artistModelArray.append(
                    ArtistModel(name: artistName, imageUrl: apiArtistModel.image?[APIImageSize.indexOf(apiImageSize: .mega)].text)
                )
            }
        }
        return artistModelArray
    }
}
