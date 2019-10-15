//
//  BusinessDBModelMapper.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 19.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

class BusinessDBModelMapper {
    
    static func albumInfoBusinessToDB(albumInfo: AlbumInfoModel) -> RealmAlbumInfoModel {
        let realmAlbumInfo = RealmAlbumInfoModel()
        
        realmAlbumInfo.artistName           = albumInfo.artistName ?? ""
        realmAlbumInfo.name                 = albumInfo.name
        realmAlbumInfo.imageUrl             = albumInfo.imageUrl ?? ""
        realmAlbumInfo.mbid                 = albumInfo.mbid
        realmAlbumInfo.albumDescription     = albumInfo.description ?? ""
        
        realmAlbumInfo.tracks.append(objectsIn: albumInfo.tracks.map {
                  trackBusinessToDB(track: $0)
               })
    
        return realmAlbumInfo
    }
    
    static func trackBusinessToDB(track: TrackModel) -> RealmTrackModel {
        let realmTrack = RealmTrackModel()
        
        realmTrack.name = track.name
        realmTrack.duration = track.duration
        
        return realmTrack
    }
    
    static func albumInfoDBToBusiness(realmAlbumInfo: RealmAlbumInfoModel) -> AlbumInfoModel {
        var tracks = [TrackModel]()
        
        tracks.append(contentsOf: realmAlbumInfo.tracks.map {
            TrackModel(name: $0.name, duration: $0.duration)
        })
        
        
        return AlbumInfoModel(
            artistName:     realmAlbumInfo.artistName,
            name:           realmAlbumInfo.name,
            imageUrl:       realmAlbumInfo.imageUrl,
            mbid:           realmAlbumInfo.mbid,
            description:    realmAlbumInfo.albumDescription,
            tracks:         tracks
        )
    }
    
    static func trackDBToBusiness(realmTrack: RealmTrackModel) -> TrackModel {
        return TrackModel(name: realmTrack.name, duration: realmTrack.duration)
    }
    
}
