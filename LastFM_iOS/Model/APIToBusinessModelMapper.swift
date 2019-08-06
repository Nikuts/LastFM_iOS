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
            if  let artistName = apiArtistModel.name,
                let artistMbid = apiArtistModel.mbid {
                
                artistModelArray.append(
                    ArtistModel(
                        name:       artistName,
                        imageUrl:   apiArtistModel.image?[APIImageSize.indexOf(apiImageSize: .mega)].text,
                        mbid:       artistMbid
                    ))
            }
        }
        return artistModelArray
    }
    
    static func mapAlbumArray(apiArtistModelArray: [APIAlbumModel]) -> [AlbumModel] {
        var artistModelArray = [AlbumModel]()
        apiArtistModelArray.forEach { apiAlbumModel in
            if  let albumName = apiAlbumModel.name,
                let alnumMbid = apiAlbumModel.mbid {
                
                artistModelArray.append(
                    AlbumModel(
                        name:       albumName,
                        imageUrl:   apiAlbumModel.image?[APIImageSize.indexOf(apiImageSize: .extralarge)].text,
                        mbid:       alnumMbid
                    ))
            }
        }
        return artistModelArray
    }
    
    static func mapAlbumInfo(apiAlbumInfoModel: APIAlbumInfoModel) -> AlbumInfoModel? {
        if  let albumName       = apiAlbumInfoModel.name,
            let albumMbid       = apiAlbumInfoModel.mbid,
            let apiAlbumTracks  = apiAlbumInfoModel.tracks?.track {
            
            return AlbumInfoModel(
                name:       albumName,
                imageUrl:   apiAlbumInfoModel.image?[APIImageSize.indexOf(apiImageSize: .extralarge)].text,
                mbid:       albumMbid,
                tracks:     mapTracksArray(apiTracksArray: apiAlbumTracks)
            )
        }
        return nil
    }
    
    private static func mapTracksArray(apiTracksArray: [APITrackModel]) -> [TrackModel] {
        var tracksArray = [TrackModel]()
        apiTracksArray.forEach { apiTrackModel in
            if  let trackName       = apiTrackModel.name,
                let trackDuration   = apiTrackModel.duration {
                
                tracksArray.append(TrackModel(name: trackName, duration: trackDuration))
            }
        }
        return tracksArray
    }
    
}
