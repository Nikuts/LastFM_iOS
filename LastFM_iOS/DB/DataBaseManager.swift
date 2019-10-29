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
    
    static func save(albumInfo: AlbumInfoModel) {
        let realm = try? Realm()
        
        if (realm?.objects(RealmAlbumInfoModel.self).filter("mbid == %@", albumInfo.mbid).count ?? -1 > 0) {
            return
        }
        
        let realmAlbumInfoModel = BusinessDBModelMapper.albumInfoBusinessToDB(albumInfo: albumInfo)
        
        try? realm?.write {
            realm?.add(realmAlbumInfoModel)
        }
    }
    
    static func getAll() -> [AlbumInfoModel] {
        let realm = try? Realm()
        
        let realmAlbumInfoModels = realm?.objects(RealmAlbumInfoModel.self)
        
        return realmAlbumInfoModels?.map {
            BusinessDBModelMapper.albumInfoDBToBusiness(realmAlbumInfo: $0)
        } ?? [AlbumInfoModel]()

    }
    
    static func delete(albumInfo: AlbumInfoModel) {
        let realm = try? Realm()
        
        if let realmAlbumInfoToDelete = realm?.objects(RealmAlbumInfoModel.self).filter("mbid == %@", albumInfo.mbid).first {
            
            try? realm?.write {
                realm?.delete(realmAlbumInfoToDelete)
            }
        }
    }
    
    static func delete(mbid: String) {
        let realm = try? Realm()
        
        if let realmAlbumInfoToDelete = realm?.objects(RealmAlbumInfoModel.self).filter("mbid == %@", mbid).first {
            
            try? realm?.write {
                realm?.delete(realmAlbumInfoToDelete)
            }
        }
    }
    
    static func isSaved(mbid: String) -> Bool {
        let realm = try? Realm()
        
        return !(realm?.objects(RealmAlbumInfoModel.self).filter("mbid == %@", mbid).isEmpty ?? true)
    }
    
    static func createObserver(observer: @escaping (
        _ albums: [AlbumInfoModel]?,
        _ deletions: [Int]?,
        _ insertions: [Int]?,
        _ modifications: [Int]?
        ) -> Void) -> NotificationToken? {
        
        let realm = try? Realm()
        
        let albums = realm?.objects(RealmAlbumInfoModel.self)
        
        return albums?.observe() { changes in
            switch changes {
                case .initial(let albums): do {
                    let albumInfoModels = albums.map {
                        BusinessDBModelMapper.albumInfoDBToBusiness(realmAlbumInfo: $0)
                    }
                    observer(Array(albumInfoModels), nil, nil, nil)
                }
                case .update(let albums, let deletions, let insertions, let modificaitons): do {
                    let albumInfoModels = albums.map {
                        BusinessDBModelMapper.albumInfoDBToBusiness(realmAlbumInfo: $0)
                    }
                    observer(Array(albumInfoModels), deletions, insertions, modificaitons)
                }
                case .error(let error):
                    observer(nil, nil, nil, nil)
                    print(error.localizedDescription)
            }
        }
    }
}
