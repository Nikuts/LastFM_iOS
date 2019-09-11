//
//  CollectionCellType.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 10.09.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import UIKit

enum CollectionCellType: String {
    case Artist = "ArtistCollectionViewCell"
    case Loading = "LoadingCollectionViewCell"
    
    func getType() -> UICollectionViewCell.Type {
        switch self {
        case .Loading:
            return LoadingCollectionViewCell.self
        case .Artist:
            return ArtistCollectionViewCell.self
        }
    }
}
