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
            if let artistName = apiArtistModel.name, let artistMbid = apiArtistModel.mbid {
                artistModelArray.append(
                    ArtistModel(name: artistName, imageUrl: apiArtistModel.image?[APIImageSize.indexOf(apiImageSize: .mega)].text, mbid: artistMbid)
                )
            }
        }
        return artistModelArray
    }
    
    static func mapAlbumArray(apiArtistModelArray: [APIAlbumModel]) -> [AlbumModel] {
        var artistModelArray = [AlbumModel]()
        apiArtistModelArray.forEach { apiAlbumModel in
            if let albumName = apiAlbumModel.name, let alnumMbid = apiAlbumModel.mbid {
                artistModelArray.append(
                    AlbumModel(name: albumName, imageUrl: apiAlbumModel.image?[APIImageSize.indexOf(apiImageSize: .extralarge)].text, mbid: alnumMbid)
                )
            }
        }
        return artistModelArray
    }
    
}
