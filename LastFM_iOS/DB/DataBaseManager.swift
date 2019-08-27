//
//  DataBaseManager.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 26.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    
    static func saveAlbumInfoModel(albumInfo: AlbumInfoModel) {
        let realm = try! Realm()
        let realmAlbumInfoModel = BusinessDBModelMapper.albumInfoBusinessToDB(albumInfo: albumInfo)
        try! realm.write {
            realm.add(realmAlbumInfoModel)
        }
    }
    
    static func getAllAlbumInfos() -> [AlbumInfoModel] {
        let realm = try! Realm()
        let realmAlbumInfoModels = realm.objects(RealmAlbumInfoModel.self)
        var albumInfoModels = [AlbumInfoModel]()
        realmAlbumInfoModels.forEach { realmAlbumInfoModel in
            albumInfoModels.append(BusinessDBModelMapper.albumInfoDBToBusiness(realmAlbumInfo: realmAlbumInfoModel))
        }
        return albumInfoModels
    }
    
}
