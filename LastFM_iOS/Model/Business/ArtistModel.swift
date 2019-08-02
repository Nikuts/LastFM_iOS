//
//  ArtistModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 31.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation

class ArtistModel {
    let name: String
    let imageUrl: String?
    
    init(name: String, imageUrl: String?) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
