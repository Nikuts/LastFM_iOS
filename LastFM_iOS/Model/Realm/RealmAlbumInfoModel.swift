//
//  RealmAlbumModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 16.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAlbumInfoModel: Object {
    @objc dynamic var artistName = ""
    @objc dynamic var name = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var mbid = ""
    @objc dynamic var albumDescription = ""
    
    let tracks = RealmSwift.List<RealmTrackModel>()
}
