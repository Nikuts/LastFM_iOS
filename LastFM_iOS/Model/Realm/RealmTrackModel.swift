//
//  RealmTrackModel.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 16.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTrackModel: Object {
    @objc dynamic var name = ""
    @objc dynamic var duration = ""
}
