//
//  CellType.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 10.09.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import UIKit

enum TableCellType: String {
    case Loading = "LoadingTableViewCell"
    case Album = "AlbumTableViewCell"
    case AlbumInfoDescription = "AlbumInfoDescriptionTableViewCell"
    case AlbumInfoTrack = "AlbumInfoTrackTableViewCell"
    
    func getType() -> UITableViewCell.Type {
        switch self {
        case .Loading:
            return LoadingTableViewCell.self
        case .Album:
            return AlbumTableViewCell.self
        case .AlbumInfoDescription:
            return AlbumInfoDescriptionTableViewCell.self
        case .AlbumInfoTrack:
            return AlbumInfoTrackTableViewCell.self
        }
    }
}
