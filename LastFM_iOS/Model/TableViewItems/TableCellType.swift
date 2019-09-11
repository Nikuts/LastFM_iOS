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
    
    func getType() -> UITableViewCell.Type {
        switch self {
        case .Loading:
            return LoadingTableViewCell.self
        case .Album:
            return AlbumTableViewCell.self
        }
    }
}
